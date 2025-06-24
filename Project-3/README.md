AWS Dynamic Multi-Resource Deployment & Advanced Referencing (Project 4)


📝 Project Description
This project pushes the boundaries of your Terraform skills by focusing intently on Outputs, Referencing, and Variables in a dynamic, multi-resource AWS environment. You'll build a highly available web server setup that adapts based on your input, requiring you to master how to connect, collect, and expose information from numerous, dynamically created cloud resources.

🌟 What You'll Build:
A custom Virtual Private Cloud (VPC).
Multiple public subnets automatically distributed across different Availability Zones, controlled by a variable.
An Internet Gateway (IGW) and associated public route table.
A security group for web servers.
Multiple EC2 instances deployed across your subnets, with their count also controlled by a variable.
🚀 Key Concepts & Terraform Skills Practiced:
This project is meticulously designed to provide deep, hands-on experience with:

Variables Mastery:
Using variables not just for single values, but for controlling the number of resources created (e.g., num_public_subnets, num_web_servers).
Defining complex variables that filter dynamic data (e.g., ami_name_filter).
Advanced Referencing:
Dynamic Resource Referencing: Learning how to reference attributes of resources created with count and for_each (e.g., the id of each of multiple subnets).
Splat Expressions ([*]): This powerful syntax will be crucial for referencing attributes from a collection of resources (e.g., aws_instance.web_server[*].public_ip to get all public IPs).
Data Source Referencing: Referencing external, dynamic AWS information like available Availability Zones (data.aws_availability_zones.current.names) and the latest AMI (data.aws_ami.latest.id).
Local Value Referencing: Employing local values to create derived data structures (like public_subnet_configs) by referencing variables and data source outputs, simplifying complex logic.
HCL Functions: Utilizing built-in functions like cidrsubnet, element, length, values, and index for sophisticated referencing and data manipulation (e.g., distributing EC2 instances across subnets or calculating dynamic CIDR blocks).
Comprehensive Outputs:
Structuring outputs to expose key information (IDs, public IPs, AZs) from multiple, dynamically created resources using splat expressions. This provides a clear interface to your deployed infrastructure.
📋 Project Requirements
1. AWS Provider Configuration
Configure the AWS provider for your chosen region (e.g., us-east-1).
(Ensure your AWS CLI is configured with appropriate credentials, e.g., using a named profile like terraform_dev).
2. Input Variables (variables.tf)
Define the following input variables with appropriate types and descriptions:

project_name: string for tagging resources (e.g., "MyApp").
environment: string for tagging (e.g., "Dev" or "Staging").
vpc_cidr_block: string for your VPC's CIDR (e.g., "10.0.0.0/16").
num_public_subnets: number (e.g., 3) to control the count of public subnets.
instance_type: string for the EC2 instance type (e.g., "t2.micro").
num_web_servers: number (e.g., 2 or 4) to control the count of EC2 instances.
ssh_access_cidr: string for the CIDR block allowed to SSH (e.g., "0.0.0.0/0" or your public IP /32).
ami_name_filter: string for filtering the AMI (e.g., "amzn2-ami-hvm-*-x86_64-gp2").
ami_owner: string for the AMI owner ID (e.g., "amazon").
3. Dynamic Data Referencing (main.tf or data.tf)
Use data "aws_availability_zones" to reference available AZ names in your region.
Use data "aws_ami" to dynamically reference the latest AMI ID based on your ami_name_filter and ami_owner variables.
4. Complex Local Value Referencing (locals.tf)
Define the following local values using advanced referencing:

common_tags: A map of common tags, referencing var.project_name and var.environment.
selected_azs: A list of strings, referencing the first var.num_public_subnets from data.aws_availability_zones.current.names.
public_subnet_configs: A map where keys are selected_azs and values are dynamically calculated CIDR blocks for each subnet. This requires referencing var.vpc_cidr_block, selected_azs, and using HCL functions like cidrsubnet and index.
5. Resource Creation with Dynamic Referencing (main.tf)
VPC, Internet Gateway, Public Route Table: Create these resources. Ensure they reference var.vpc_cidr_block and local.common_tags.
Multiple Public Subnets:
Create aws_subnet resources using for_each = local.public_subnet_configs.
Each subnet's cidr_block must reference each.value and availability_zone must reference each.key.
Each subnet must reference aws_vpc.main.id.
Route Table Associations:
Create aws_route_table_association resources using for_each = aws_subnet.public (which references all your dynamically created subnets).
Each association must reference each.value.id (the subnet ID) and aws_route_table.public.id.
Security Group:
Create an aws_security_group. Its rules must reference var.ssh_access_cidr. It must reference aws_vpc.main.id.
Multiple EC2 Instances:
Create aws_instance resources using count = var.num_web_servers.
The ami must reference data.aws_ami.latest.id.
The instance_type must reference var.instance_type.
The subnet_id must reference one of the dynamically created public subnets by using count.index with an HCL function like element to cycle through the list of aws_subnet.public IDs.
The vpc_security_group_ids must reference your security group's ID.
6. Advanced Outputs (outputs.tf)
Define the following outputs using splat expressions ([*]) for collections:

vpc_id: Output the ID of the created VPC.
public_subnet_ids: A list of all created public subnet IDs, referencing aws_subnet.public[*].id.
public_subnet_azs: A list of all created public subnet Availability Zones, referencing aws_subnet.public[*].availability_zone.
web_server_public_ips: A list of the public IP addresses of all created EC2 instances, referencing aws_instance.web_server[*].public_ip.
web_server_instance_ids: A list of the instance IDs of all created EC2 instances, referencing aws_instance.web_server[*].id.
📁 Project Structure
Your project directory should look like this:

.
├── main.tf        # Contains AWS resources, data sources
├── variables.tf   # Defines input variables
├── outputs.tf     # Defines output values
├── locals.tf      # Defines local values
└── terraform.tfvars # (Optional) For providing variable values (keep out of Git for sensitive info!)
├── README.md      # This file!
