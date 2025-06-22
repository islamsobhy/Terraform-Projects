provider "aws" {
  profile = "terrafrom-dev"
  region  = "us-east-1"
}


data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.VPC_CIDR_Block
  tags       = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = local.common_tags
}

resource "aws_subnet" "public_Subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet
  map_public_ip_on_launch = true
  availability_zone       = local.chosen-az
  tags                    = local.common_tags

}


resource "aws_route_table" "rt_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_Subnet.id
  route_table_id = aws_route_table.rt_table.id
}
