resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(local.common_tags, { Name = "${var.env}-vpc"} )
}

resource "aws_vpc_peering_connection" "peering" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  tags = merge(local.common_tags, { Name = "${var.env}-peering"} )

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, { Name = "${var.env}-igw"} )

}

resource "aws_eip" "ngw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id = lookup(lookup(module.public_subnets, "public", null ), "subnet_ids", null)[0]

  tags = merge(local.common_tags, { Name = "${var.env}-ngw"} )
}

