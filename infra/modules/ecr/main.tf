resource "aws_ecr_repository" "main" {
  tags = { Name = var.name }

  # リポジトリ名
  name = var.name

  # イメージタグの変更・上書きを許可するか
  # mutable  : 許可(試験環境向け)
  # immutable: 許可しない(本番環境向け)
  image_tag_mutability = var.image_tag_mutability

  # プッシュされたタイミングで、自動的に脆弱性スキャンを開始するか否か
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  # イメージが保存されていてもリポジトリを削除可能か否か
  force_delete = var.force_delete
}

# 最新の 30 個だけを残してそれ以外を削除するポリシー
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}