# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# VPC CIDR block
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Public Subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

# Public Subnet CIDR block
output "public_subnet_cidr_block" {
  description = "The CIDR block of the public subnet"
  value       = aws_subnet.public.cidr_block
}

# Availability Zone of the Public Subnet
output "public_subnet_az" {
  description = "The Availability Zone of the public subnet"
  value       = aws_subnet.public.availability_zone
}

# Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# Route Table ID
output "route_table_id" {
  description = "The ID of the Route Table"
  value       = aws_route_table.public.id
}

# Route Table Association ID
output "route_table_association_id" {
  description = "The ID of the Route Table Association"
  value       = aws_route_table_association.public.id
}