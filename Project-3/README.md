# 🚀 Project 3: AWS Dynamic Multi-Resource Deployment & Advanced Referencing



## 📝 Project Overview & Goal

This project is meticulously crafted to **deeply challenge and solidify your understanding** of three core Terraform concepts: **Outputs**, **Referencing**, and **Variables**. You will build a highly available and flexible web server infrastructure on AWS, where the complexity arises from dynamically creating multiple resources and intricately connecting them.

The primary goal is to master how to:
* **Input dynamic configurations** using variables.
* **Intelligently reference** attributes across numerous, dynamically provisioned cloud resources.
* **Effectively collect and expose crucial infrastructure information** as structured outputs.

### ✨ What You'll Build:

* A custom **Virtual Private Cloud (VPC)**.
* **Multiple public subnets** automatically distributed across different AWS Availability Zones (AZs), with their count controlled by an input variable.
* An **Internet Gateway (IGW)** and a public route table to enable internet connectivity.
* A **security group** configured for your web servers.
* **Multiple EC2 instances** deployed strategically across your subnets, with their number also determined by an input variable.

## 🧠 Key Concepts & Terraform Skills Practiced:

This project specifically targets and enhances your proficiency in:

* **1. Variables Mastery:**
    * **Dynamic Counts:** Using `number` variables (e.g., `num_public_subnets`, `num_web_servers`) to control the *quantity* of resources Terraform provisions.
    * **Flexible Inputs:** Defining variables for dynamic data filtering (e.g., `ami_name_filter`) to make your configuration adaptable without hardcoding.

* **2. Advanced Referencing:**
    * **Referencing Collections (Splat Expressions `[*]`)**: Mastering this powerful syntax (e.g., `aws_instance.web_server[*].public_ip`) to easily extract and **reference** attributes from *all* instances of a dynamically created resource, regardless of how many there are.
    * **Dynamic Data Sources:** **Referencing** external, live AWS information (e.g., `data.aws_availability_zones.current.names` for AZs, `data.aws_ami.latest.id` for the newest AMI) to build self-adapting infrastructure.
    * **Inter-Resource Linking:** Precisely **referencing** attributes from one resource (`aws_vpc.main.id`) to define properties for another (`aws_subnet.public.vpc_id`), ensuring correct dependencies.
    * **Local Value Referencing:** Leveraging `locals` to create intermediate, derived data structures (like `public_subnet_configs`) by **referencing** and combining various variables and data source outputs. This significantly improves code readability and maintainability.
    * **HCL Functions for Referencing:** Utilizing built-in functions such as `cidrsubnet`, `element`, `length`, `values`, and `index` to perform calculations and manipulate lists/maps when **referencing** and distributing resources (e.g., ensuring EC2 instances are spread across different subnets).

* **3. Comprehensive Outputs:**
    * **Exposing Collections:** Structuring your `outputs.tf` to **output** not just single values, but *lists* of properties (IDs, public IPs, AZs) from **multiple, dynamically created resources**. This directly applies your understanding of **splat expressions** for a clear and programmatic interface to your deployed stack.

---

## 📋 Requirements & Implementation Details

### 1. AWS Provider Configuration

* Configure the AWS provider for your chosen region (e.g., `us-east-1`).
* *(Ensure your AWS CLI is configured with appropriate credentials, e.g., using a named profile like `terraform_dev`).*

### 2. Input Variables (`variables.tf`)

Define the following input **variables** with clear types and descriptions:

* `project_name`: `string` for tagging resources (e.g., `"MyApp"`).
* `environment`: `string` for tagging (e.g., `"Dev"` or `"Staging"`).
* `vpc_cidr_block`: `string` for your VPC's CIDR (e.g., `"10.0.0.0/16"`).
* `num_public_subnets`: `number` (e.g., `3`) – this variable directly controls the **count** of subnets created.
* `instance_type`: `string` for the EC2 instance type (e.g., `"t2.micro"`).
* `num_web_servers`: `number` (e.g., `2` or `4`) – this variable directly controls the **count** of web servers created.
* `ssh_access_cidr`: `string` for the CIDR block allowed to SSH (e.g., `"0.0.0.0/0"` for simplicity, or your specific public IP `/32`).
* `ami_name_filter`: `string` for filtering the AMI (e.g., `"amzn2-ami-hvm-*-x86_64-gp2"` for Amazon Linux 2).
* `ami_owner`: `string` for the AMI owner ID (e.g., `"amazon"`).

### 3. Dynamic Data Referencing (`main.tf` or `data.tf`)

* Use `data "aws_availability_zones"` to **reference** and fetch the names of all available AZs in your configured region.
* Use `data "aws_ami"` to dynamically **reference** and select the latest AMI ID based on your `var.ami_name_filter` and `var.ami_owner` **variables**.

### 4. Complex Local Value Referencing (`locals.tf`)

Define the following local values using advanced **referencing**:

* `common_tags`: A `map` containing common tags (`Project`, `Environment`), **referencing** `var.project_name` and `var.environment`.
* `selected_azs`: A `list` of strings that **references** the first `var.num_public_subnets` from `data.aws_availability_zones.current.names`.
* `public_subnet_configs`: A `map` where keys are the selected AZs and values are dynamically calculated CIDR blocks for each public subnet. This requires **referencing** `var.vpc_cidr_block`, `local.selected_azs`, and using **HCL functions** like `cidrsubnet` and `index` for precise network allocation.

### 5. Resource Creation with Dynamic Referencing (`main.tf`)

* **VPC, Internet Gateway, Public Route Table:**
    * Create `aws_vpc`, `aws_internet_gateway`, and `aws_route_table` resources.
    * Ensure they correctly **reference** `var.vpc_cidr_block` and `local.common_tags`.
* **Multiple Public Subnets (using `for_each`):**
    * Create `aws_subnet` resources using **`for_each = local.public_subnet_configs`**.
    * Each subnet's `cidr_block` must **reference** `each.value` and its `availability_zone` must **reference** `each.key`.
    * Each subnet must **reference** `aws_vpc.main.id`.
* **Route Table Associations (using `for_each`):**
    * Create `aws_route_table_association` resources using **`for_each = aws_subnet.public`** (which implicitly **references** all your dynamically
    * * Each association must **reference** `each.value.id` (the subnet ID) and `aws_route_table.public.id`.
* **Security Group:**
    * Create an `aws_security_group` resource.
    * Its inbound/outbound rules must **reference** `var.ssh_access_cidr`. It must also **reference** `aws_vpc.main.id`.
* **Multiple EC2 Instances (using `count`):**
    * Create `aws_instance` resources using **`count = var.num_web_servers`**.
    * The `ami` must **reference** `data.aws_ami.latest.id`.
    * The `instance_type` must **reference** `var.instance_type`.
    * The `subnet_id` must **reference** one of the dynamically created public subnets by using `count.index` with the `element` **function** to cycle through the **referenced** list of `aws_subnet.public` IDs. This is a critical point for demonstrating complex **referencing**.
    * The `vpc_security_group_ids` must **reference** your security group's ID.

### 6. Advanced Outputs (`outputs.tf`)

Define the following **outputs** using **splat expressions (`[*]`)** to expose collections of information:

* `vpc_id`: The ID of the created VPC.
* `public_subnet_ids`: A **list** of all created public subnet IDs, **referencing** `aws_subnet.public[*].id`.
* `public_subnet_azs`: A **list** of all created public subnet Availability Zones, **referencing** `aws_subnet.public[*].availability_zone`.
* `web_server_public_ips`: A **list** of the public IP addresses of all created EC2 instances, **referencing** `aws_instance.web_server[*].public_ip`.
* `web_server_instance_ids`: A **list** of the instance IDs of all created EC2 instances, **referencing** `aws_instance.web_server[*].id`.

---

## 📁 Project Structure

Your project directory should be organized as follows:

.
├── main.tf        # 🌐 Defines AWS resources (VPC, Subnet, IGW, Route Table, EC2, SG) & data sources.
├── variables.tf   # 💡 Centralizes all input variables for customization.
├── outputs.tf     # 📊 Exports key information about deployed resources.
├── locals.tf      # ⚙️ Stores derived values and complex data structures.
├── terraform.tfvars # (Optional) Custom variable values for your environment (⚡️ exclude from Git for secrets!).
└── README.md      # 📖 This comprehensive guide to the project.
