data "aws_region" "current" {}

#------------------------------
# iam policy
#------------------------------
# policy, role の中身・実態は, aws_iam_policy_document に記述
# 用意するは2つ (ECSタスク実行権限, SecretManagerアクセス権限)

resource "aws_iam_policy" "secretmanager_read" {
  description = "ECS -> SecretManager Access to fetch secrets"
  tags        = { Name = var.policy_name }
  name        = var.policy_name
  policy      = data.aws_iam_policy_document.secretmanager_read.json
}

data "aws_iam_policy_document" "secretmanager_read" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue", # 値の取得
      "secretsmanager:DescribeSecret", # 値の読込み
      "kms:Decrypt"                    # 値の復号(KMSで暗号化されているため)
    ]
    resources = ["*"]
  }
}

#------------------------------
# iam role
#------------------------------
resource "aws_iam_role" "ecs_exec" {
  description        = "Assume role for ECS"
  tags               = { Name = var.role_name }
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#------------------------------
# role_policy attachment
#------------------------------
# 作成した IAMロール と IAMポリシー を紐付ける

### ecs secretmanager access ###
resource "aws_iam_role_policy_attachment" "ecs_secretmanager_access" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = aws_iam_policy.secretmanager_read.arn
}

### ecs task excution ### (こちらはマネージドロール)
resource "aws_iam_role_policy_attachment" "ecs_exec_task" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#------------------------------
# Cloudwatch Log Group
#------------------------------
resource "aws_cloudwatch_log_group" "webapp" {
  tags              = { Name = var.log_name }
  name              = var.log_name
  retention_in_days = var.retention_in_days
}

#------------------------------
# ecs
#------------------------------
### cluster ###
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
  tags = { Name = var.cluster_name }

  # Cloudwatchにメトリクスを送信する機能
  setting {
    name  = "containerInsights"    # 固定(これしか指定できない)
    value = var.container_insights # enable or disabled
  }
}

### task definition ###
resource "aws_ecs_task_definition" "webapp" {
  family = var.family

  # ECSが使用するIAMロール
  execution_role_arn       = aws_iam_role.ecs_exec.arn
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory

  # 「このタスクは X86_64 (AMD64) で動かす」と明示的に設定
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  ### container definition ###
  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.image_uri
      # コンテナフラグ(trueに指定されたコンテナが停止するとタスク全体が停止)
      essential = true
      # ポートフォワーディング設定(Fagateは、container,hostのportを同じに設定)
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MYSQL_HOST"
          value = var.mysql_host
        },
        {
          name  = "MYSQL_USER"
          value = var.mysql_username
        },
        {
          name  = "MYSQL_PASSWORD"
          value = var.mysql_password
        },
        {
          name  = "MYSQL_DATABASE"
          value = var.mysql_database
        },
        {
          name  = "MYSQL_SSL"
          value = var.mysql_ssl
        }
      ]
      # ログの出力先(logDriver="awslogs" に指定するとCloudWatch logs にログ転送する)
      logConfiguration = {
        logDriver = "awslogs"
        # 具体的な転送先を指定 (どのロググループ, どのリージョン)
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp.id
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

### service ###
resource "aws_ecs_service" "webapp" {
  tags = { Name = var.service_name }

  name            = var.service_name
  cluster         = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}