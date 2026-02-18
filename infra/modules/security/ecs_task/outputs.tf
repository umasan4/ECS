output "iam_role_arn" {
  description = "ECS タスク定義の task_role_arn に指定するロール ARN"
  value       = aws_iam_role.main.arn
}

output "iam_role_name" {
  description = "IAM ロール名"
  value       = aws_iam_role.main.name
}