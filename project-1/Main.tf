provider "aws" {
  region  = "us-east-1"
  profile = "terraform_projects"
}




resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = var.ec2-type
  tags = {
    Name = var.resource-name
  }
}
