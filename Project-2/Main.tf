
provider "aws" {
  profile = "terraform-dev"
  region  = "us-east-1"
}


resource "aws_vpc" "main-VPC" {
  cidr_block = var.vpc_cidr_block
  tags       = local.info
}


resource "aws_subnet" "public-subnets" {
  for_each   = var.public_subnet_cidrs
  cidr_block = each.value
  vpc_id     = aws_vpc.main-VPC.id

}


resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main-VPC.id
  tags   = local.info
}


resource "aws_route_table" "public-rout-table" {
  vpc_id = aws_vpc.main-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = local.info
}


resource "aws_security_group" "web-sg" {
  description = "Security group for web servers allowing HTTP, HTTPS, and SSH access."
  vpc_id      = aws_vpc.main-VPC.id

  # Inbound Rule: Allow HTTP (Port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTP traffic"
  }

  # Inbound Rule: Allow HTTPS (Port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTPS traffic"
  }
  # Inbound Rule: Allow SSH (Port 22) from specified CIDR
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_access_cidr] # Uses the variable for SSH access control
    description = "Allow inbound SSH access"
  }
  # Outbound Rule: Allow all traffic to anywhere
  egress {
    from_port   = 0             # All ports
    to_port     = 0             # All ports
    protocol    = "-1"          # All protocols (-1 means all, or "all")
    cidr_blocks = ["0.0.0.0/0"] # To anywhere
    description = "Allow all outbound traffic"
  }
  tags = local.info

}

resource "aws_instance" "web-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.instance_count # Use the variable for instance count from Project 2 requirements

  # Correct way to distribute instances across subnets created with for_each
  subnet_id = element(values(aws_subnet.public_subnets)[*].id, count.index % length(values(aws_subnet.public_subnets)))

  # Correct way to associate a security group (it expects a list of IDs)
  vpc_security_group_ids = [aws_security_group.web_sg.id] # Assuming web_sg is a single SG, not created with count/for_each

  # ... add tags, user_data if desired ...

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-WebServer-${count.index + 1}"
  })
}
