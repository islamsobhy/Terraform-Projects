Project 2: Highly Available and Scalable Web Application Infrastructure (Part 1 - Core Networking & Basic EC2 Scaling)

Scenario:
You need to build a highly available and scalable web application environment on AWS. This involves setting up a custom Virtual Private Cloud (VPC), multiple public subnets across different Availability Zones (AZs), and deploying a small cluster of web servers (EC2 instances) within these subnets.

Core Concepts to Practice:

  count Meta-Argument: To create multiple similar resources.
  for_each Meta-Argument: To create resources based on more complex data structures.
  local Values: To define reusable intermediate values.
  Data Sources: To fetch information (like available AZs).
  Terraform Functions: Such as cidrsubnet for networking.

Requirements:

1-AWS Provider Configuration:
  Configure the AWS provider for your chosen region (e.g., us-east-1).
  (Keep using your terraform_dev profile if you set it up).

2-Input Variables (variables.tf):
  project_name: A string for tagging resources (e.g., "MyApp").
  environment: A string for tagging (e.g., "Dev" or "Staging").
  vpc_cidr_block: A string for your VPC's CIDR (e.g., "10.0.0.0/16").
  public_subnet_cidrs: A list of strings representing the CIDR blocks for your public subnets (e.g., ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]). Define at least two.
  instance_type: A string for the EC2 instance type (e.g., "t2.micro").
  ami_id: A string for the AMI ID (use a common Amazon Linux 2 or Ubuntu LTS AMI for your region).
  instance_count: A number for how many web server instances to deploy (e.g., 2 or 3).
  ssh_access_cidr: A string for the CIDR block allowed to SSH (e.g., "0.0.0.0/0" for now, or your public IP /32).

3-Local Values (locals.tf - recommended):
  Define a local value, common_tags, which is a map containing common tags (Project and Environment) derived from your project_name and environment variables. You'll apply these tags to most resources.
  Define a local value, azs, which fetches the availability zones for your region using a data source. This will be crucial for distributing subnets.
  Hint: Look for data "aws_availability_zones" in Terraform documentation.

4-VPC Creation (main.tf):
  Create an aws_vpc resource using the vpc_cidr_block variable.
  Apply your common_tags to the VPC.

5-Internet Gateway (IGW) (main.tf):
  Create an aws_internet_gateway and attach it to your VPC.
  Apply your common_tags to the IGW.
  
6-Public Subnets (main.tf - using for_each or count):
  Create aws_subnet resources for your public subnets.
  Challenge: Use for_each (preferred for this structure) or count to iterate through your public_subnet_cidrs variable.
  If using for_each, map each CIDR to an Availability Zone from your local.azs list (you'll need to figure out how to assign unique AZs sequentially or based on the map's keys).
  Ensure map_public_ip_on_launch is set to true.
  Apply your common_tags to each subnet, along with a unique Name tag (e.g., "MyApp-PublicSubnet-us-east-1a").

7-Public Route Table (main.tf):
  Create an aws_route_table for your public subnets, associated with your VPC.
  Add a route for 0.0.0.0/0 pointing to your Internet Gateway.
  Apply your common_tags to the route table.
  Create aws_route_table_association resources to associate each public subnet with this public route table. You'll need to iterate using for_each or count again based on how you created your subnets.

8-Security Group for Web Servers (main.tf):
  Create an aws_security_group resource.
  Allow inbound HTTP (port 80) and HTTPS (port 443) from 0.0.0.0/0.
  Allow inbound SSH (port 22) from your ssh_access_cidr variable.
  Allow all outbound traffic.
  Associate this security group with your VPC.
  Apply your common_tags to the security group, plus a descriptive Name.

9-EC2 Instances (main.tf - using count):
  Create aws_instance resources for your web servers.
  Challenge: Use the count meta-argument with your instance_count variable.
  Distribute these instances across your public subnets using the subnet_id argument. You'll need to reference the output of your subnet creation and use an index or modulo operator (%) with count.index to cycle through available subnets.
  Use the instance_type and ami_id variables.
  Associate the web server security group.
  Apply your common_tags to each instance, along with a unique Name tag (e.g., "MyApp-WebServer-1", "MyApp-WebServer-2").

10-Outputs (outputs.tf):
  vpc_id: Output the ID of the created VPC.
  public_subnet_ids: Output a list of the IDs of all created public subnets.
  public_instance_ips: Output a list of the public IP addresses of all created EC2 instances.


File Structure Recommendation:
  main.tf
  variables.tf
  outputs.tf
  locals.tf


Important Hints:
  data "aws_availability_zones": This data source is your friend for getting AZ names. You can filter the list if you only want a certain number of AZs.
  count.index or each.key/each.value: These are crucial when iterating with count or for_each.
  aws_subnet.*.id or aws_instance.*.public_ip: When accessing attributes of resources created with count or for_each, you'll use * (splat expression) to get a list of all their attributes. E.g., aws_subnet.public.*.id.
