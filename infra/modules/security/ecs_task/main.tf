#------------------------------
# IAM Role
#------------------------------
# Assume Role Policy
resource "aws_iam_role" "main" {
  name = var.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })
  tags = { Name = var.name }
}

#------------------------------
# IAM Policy Attachment
#------------------------------
# IAM　Roleに紐付けるポリシー
# 不要なためコメントアウト
# resource "aws_iam_role_policy_attachment" "main" {
#   role       = aws_iam_role.main.name
#   policy_arn = var.policy_arn
# }