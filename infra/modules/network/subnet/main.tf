resource "aws_subnet" "main" {
  vpc_id = var.vpc_id

  # map(object)
  for_each                = var.subnets
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags                    = { Name = "${var.name}-${each.key}" }
}

resource "aws_route_table_association" "main" {
  for_each       = var.subnets
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = var.route_table_id
}