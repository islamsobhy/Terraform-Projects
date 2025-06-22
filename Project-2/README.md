# AWS Foundational Networking with Dynamic Data & Local Organization (Project 3)


## 📝 Project Description

This project focuses on building a basic yet robust networking foundation on Amazon Web Services (AWS) using **Terraform Infrastructure as Code (IaC)**. The core objective is to practice and understand how to leverage **Data Sources** to fetch dynamic information from AWS and utilize **Local Values** for better code organization and maintainability.

### 🌟 What You'll Build:

* A custom **Virtual Private Cloud (VPC)**.
* A **single public subnet** dynamically placed in an available Availability Zone.
* An **Internet Gateway (IGW)** to enable internet connectivity for the VPC.
* A **public route table** and its association to direct traffic for the public subnet.

## 🚀 Key Concepts & Terraform Skills Practiced:

This project is specifically designed to help you master:

* **`Data Sources`**: How to query and fetch information about existing AWS resources or dynamic environment details (e.g., getting a list of available Availability Zones in a region).
* **`Local Values`**: Effectively defining and using intermediate, reusable values within your Terraform configuration to avoid repetition and improve clarity.
* **Basic AWS Networking:** Reinforcing the fundamental components of a VPC setup.

## 📋 Project Requirements

### 1. AWS Provider Configuration

* Configure the AWS provider for your chosen region (e.g., `us-east-1`).
* (Ensure your AWS CLI is configured with appropriate credentials, e.g., using a named profile like `terraform_dev`).

### 2. Input Variables (`variables.tf`)

Define the following input variables with appropriate types and descriptions:

* `project_name`: A `string` for tagging resources (e.g., `"SimpleVPC"`).
* `environment`: A `string` for tagging (e.g., `"Dev"`).
* `vpc_cidr_block`: A `string` for your VPC's CIDR (e.g., `"10.0.0.0/16"`).
* `public_subnet_cidr`: A `string` for your *single* public subnet's CIDR (e.g., `"10.0.1.0/24"`).

### 3. Data Source (`main.tf` or `data.tf`)

* Use the `data "aws_availability_zones"` resource to fetch a list of all available Availability Zones in your configured AWS region.
    * *Hint:* You can access the list of names via `data.aws_availability_zones.current.names`.

### 4. Local Values (`locals.tf`)

Define the following local values for better organization:

* `common_tags`: A `map` containing common tags (`Project` and `Environment`) derived from your `var.project_name` and `var.environment` variables.
* `chosen_az`: A `string` that picks the *first* Availability Zone from the list fetched by your `aws_availability_zones` data source. This ensures your subnet is created in a valid AZ dynamically.

### 5. VPC Creation (`main.tf`)

* Create an `aws_vpc` resource using the `var.vpc_cidr_block`.
* Apply your `local.common_tags` to the VPC.

### 6. Internet Gateway (IGW) (`main.tf`)

* Create an `aws_internet_gateway` and attach it to your VPC.
* Apply your `local.common_tags` to the IGW.

### 7. Single Public Subnet (`main.tf`)

* Create an `aws_subnet` resource for your *single* public subnet.
* Associate it with your VPC.
* Use the `var.public_subnet_cidr` for its CIDR block.
* Assign its `availability_zone` to your `local.chosen_az`.
* Ensure `map_public_ip_on_launch` is set to `true`.
* Apply your `local.common_tags` and a unique `Name` tag (e.g., `"${local.project_name}-${local.environment}-PublicSubnet-AZ1"`).

### 8. Public Route Table (`main.tf`)

* Create an `aws_route_table` for your public subnet, associated with your VPC.
* Add a route for `0.0.0.0/0` pointing to your Internet Gateway.
* Apply your `local.common_tags`.

### 9. Route Table Association (`main.tf`)

* Create an `aws_route_table_association` resource to associate your single public subnet with your public route table.

### 10. Outputs (`outputs.tf`)

Define the following outputs for easy retrieval after deployment:

* `vpc_id`: The ID of the created VPC.
* `public_subnet_id`: The ID of the single public subnet.
* `public_subnet_az`: The Availability Zone of the public subnet.

---

## 📁 Project Structure

Your project directory should look like this:
Okay, understood! Here's the README.md file for Project 3: Foundational Networking with Dynamic Data & Local Organization, formatted for easy readability on GitHub.

You can create a new folder for Project3 in your Terraform-Projects repository and place this file, along with your Terraform code files (main.tf, variables.tf, outputs.tf, locals.tf, terraform.tfvars), inside it.

Markdown

# AWS Foundational Networking with Dynamic Data & Local Organization (Project 3)

![Architecture Diagram Placeholder](https://via.placeholder.com/800x400?text=Your+Architecture+Diagram+Here)
*(Replace this with a simple diagram of your VPC, single public Subnet, IGW, and Route Table.)*

## 📝 Project Description

This project focuses on building a basic yet robust networking foundation on Amazon Web Services (AWS) using **Terraform Infrastructure as Code (IaC)**. The core objective is to practice and understand how to leverage **Data Sources** to fetch dynamic information from AWS and utilize **Local Values** for better code organization and maintainability.

### 🌟 What You'll Build:

* A custom **Virtual Private Cloud (VPC)**.
* A **single public subnet** dynamically placed in an available Availability Zone.
* An **Internet Gateway (IGW)** to enable internet connectivity for the VPC.
* A **public route table** and its association to direct traffic for the public subnet.

## 🚀 Key Concepts & Terraform Skills Practiced:

This project is specifically designed to help you master:

* **`Data Sources`**: How to query and fetch information about existing AWS resources or dynamic environment details (e.g., getting a list of available Availability Zones in a region).
* **`Local Values`**: Effectively defining and using intermediate, reusable values within your Terraform configuration to avoid repetition and improve clarity.
* **Basic AWS Networking:** Reinforcing the fundamental components of a VPC setup.

## 📋 Project Requirements

### 1. AWS Provider Configuration

* Configure the AWS provider for your chosen region (e.g., `us-east-1`).
* (Ensure your AWS CLI is configured with appropriate credentials, e.g., using a named profile like `terraform_dev`).

### 2. Input Variables (`variables.tf`)

Define the following input variables with appropriate types and descriptions:

* `project_name`: A `string` for tagging resources (e.g., `"SimpleVPC"`).
* `environment`: A `string` for tagging (e.g., `"Dev"`).
* `vpc_cidr_block`: A `string` for your VPC's CIDR (e.g., `"10.0.0.0/16"`).
* `public_subnet_cidr`: A `string` for your *single* public subnet's CIDR (e.g., `"10.0.1.0/24"`).

### 3. Data Source (`main.tf` or `data.tf`)

* Use the `data "aws_availability_zones"` resource to fetch a list of all available Availability Zones in your configured AWS region.
    * *Hint:* You can access the list of names via `data.aws_availability_zones.current.names`.

### 4. Local Values (`locals.tf`)

Define the following local values for better organization:

* `common_tags`: A `map` containing common tags (`Project` and `Environment`) derived from your `var.project_name` and `var.environment` variables.
* `chosen_az`: A `string` that picks the *first* Availability Zone from the list fetched by your `aws_availability_zones` data source. This ensures your subnet is created in a valid AZ dynamically.

### 5. VPC Creation (`main.tf`)

* Create an `aws_vpc` resource using the `var.vpc_cidr_block`.
* Apply your `local.common_tags` to the VPC.

### 6. Internet Gateway (IGW) (`main.tf`)

* Create an `aws_internet_gateway` and attach it to your VPC.
* Apply your `local.common_tags` to the IGW.

### 7. Single Public Subnet (`main.tf`)

* Create an `aws_subnet` resource for your *single* public subnet.
* Associate it with your VPC.
* Use the `var.public_subnet_cidr` for its CIDR block.
* Assign its `availability_zone` to your `local.chosen_az`.
* Ensure `map_public_ip_on_launch` is set to `true`.
* Apply your `local.common_tags` and a unique `Name` tag (e.g., `"${local.project_name}-${local.environment}-PublicSubnet-AZ1"`).

### 8. Public Route Table (`main.tf`)

* Create an `aws_route_table` for your public subnet, associated with your VPC.
* Add a route for `0.0.0.0/0` pointing to your Internet Gateway.
* Apply your `local.common_tags`.

### 9. Route Table Association (`main.tf`)

* Create an `aws_route_table_association` resource to associate your single public subnet with your public route table.

### 10. Outputs (`outputs.tf`)

Define the following outputs for easy retrieval after deployment:

* `vpc_id`: The ID of the created VPC.
* `public_subnet_id`: The ID of the single public subnet.
* `public_subnet_az`: The Availability Zone of the public subnet.

---

## 📁 Project Structure

Your project directory should look like this:

.
├── main.tf        # Contains AWS resources (VPC, Subnet, IGW, Route Table)
├── variables.tf   # Defines input variables
├── outputs.tf     # Defines output values
├── locals.tf      # Defines local values and data sources
└── terraform.tfvars # (Optional) For providing variable values (keep out of Git for sensitive info!)
├── README.md      # This file!
