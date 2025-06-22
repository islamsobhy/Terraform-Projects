output "VPC_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_Subnet.id
}

output "public-subnet-az" {
  value = aws_subnet.public_Subnet.availability_zone
}
