resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(local.common_tags, { Name = "${var.env}-vpc"} )
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets_cidr[count.index]

  tags = merge(local.common_tags, { Name = "${var.env}-public_subnet-${count.index+1}"} )

}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_cidr[count.index]

  tags = merge(local.common_tags, { Name = "${var.env}-private_subnet-${count.index+1}"} )

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