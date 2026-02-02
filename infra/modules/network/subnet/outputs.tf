output "ids" {
  description = "作成されたサブネットIDのマップ (key => subnet_id)"
  # for_eachで作ったリソースは values(...) で値のリストを取り出す
  value = { for k, v in aws_subnet.main : k => v.id }
}