locals {
  # common_tags: A map containing common tags (Project and Environment)
  # derived from your var.project_name and var.environment variables.
  common_tags = {
    Project     = var.project_name
    Environment = var.enviroment
  }



  chosen-az = data.aws_availability_zones.azs
}
