# policy, role の中身・実態は, aws_iam_policy_document に記述
# 用意するは2つ (ECSタスク実行権限, SecretManagerアクセス権限)

#------------------------------
# iam policy
#------------------------------
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
  retention_in_days = 7 # ログの保存期間(デフォルトは無期限)
}
