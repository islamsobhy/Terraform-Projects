variable "project_name" {
  default = "my-vpc"
}

variable "enviroment" {
  default = "dev"
}

variable "VPC_CIDR_Block" {
  default = "10.0.0.0/16"
}

variable "public_subnet" {
  default = "10.0.1.0/24"
}
