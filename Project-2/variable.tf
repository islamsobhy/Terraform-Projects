variable "project_nam" {
  default = "MyApp"
}

variable "environment" {
  default = "Staging"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "instance-type" {
  default = "t2.micro"
}


variable "ami-id" {
  default = "ami-09e6f87a47903347c"
}


variable "instancve-count" {
  default = "3"
}

variable "ssh_access_cidr" {
  default = "156.201.8.204"
}
