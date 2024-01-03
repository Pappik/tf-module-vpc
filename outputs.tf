output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.peering.id
}

output "public_subnet_ids" {
  value = module.public_subnets.subnet_ids
}