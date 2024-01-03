resource "aws_subnet" "subnets" {
  count  = length(var.cidr_block)
  cidr_block = var.cidr_block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id

  tags = merge(local.common_tags, { Name = "${var.env}-${var.name}-subnet-${count.index+1}"} )

}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id


  route {
    cidr_block        = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = var.vpc_peering_connection_id
  }

  tags = merge(local.common_tags, { Name = "${var.env}-${var.name}-route_table" } )
}

resource "aws_route_table_association" "route-assoc" {
  count          = length(aws_subnet.subnets)
  subnet_id      = aws_subnet.subnets.*.id[count.index]
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route" "igw_route" {
  count          = var.internet_gw == null ? 0 : 1
  route_table_id = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gw
}
