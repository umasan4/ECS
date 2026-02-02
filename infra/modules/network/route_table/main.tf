resource "aws_route_table" "main" {
  vpc_id = var.vpc_id
  tags   = { Name = var.name }
}

resource "aws_route" "main" {
  route_table_id = aws_route_table.main.id

  # object
  for_each               = var.routes
  destination_cidr_block = each.value.cidr_block
  network_interface_id   = each.value.network_interface_id
  gateway_id             = each.value.gateway_id
}

# aws_route_table_association は、modules/subnet/main.tf に定義