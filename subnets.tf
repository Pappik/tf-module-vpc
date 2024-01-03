#module "subnet" {
#  source = "./subnets"
#
#  availability_zone = var.availability_zone
#  default_vpc_id = var.default_vpc_id
#  env = var.env
#
#  for_each = var.subnets
#  cidr_block = each.value.cidr_block
#  name       = each.value.name
#  internet_gw = lookup(each.value, "internet_gw", false )
##  nat_gw = lookup(each.value, "nat_gw", false )
#
#
#  vpc_id = aws_vpc.main.id
#  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
#  tags                      = local.common_tags
#  gateway_id                = aws_internet_gateway.igw.id
#}


#resource "aws_route" "internet_gw_route" {
#  count       = var.internet_gw ? 1 : 0
#  route_table_id = aws_route_table.route_table.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = var.internet_gw
#}
#
#resource "aws_internet_gateway" "igw" {
#  count       = var.internet_gw ? 1 : 0
#  vpc_id = var.vpc_id
#
#  tags = merge(local.common_tags, { Name = "${var.env}-igw"} )
#
#}
#
#resource "aws_eip" "eip" {
#   domain   = "vpc"
#}
#
#resource "aws_nat_gateway" "ngw" {
#  count         = var.nat_gw ? 1 : 0
#  allocation_id = aws_eip.eip.id
#  subnet_id     = aws_subnet.public.*.id[0]
#
#  tags = merge(local.common_tags, { Name = "${var.env}-ngw"} )
#}