locals {
  info = {
    project    = "Highly Available & Scalable Web Application Infrastructure"
    enviroment = "dev"
  }
}

locals {
  azs = data.aws_availability_zone.azs
}

data "aws_availability_zone" "azs" {}

