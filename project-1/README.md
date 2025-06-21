Project 1 (Part 1): Basic EC2 Instance with Variables


Scenario:

You need to deploy a single EC2 instance on AWS. This instance will serve as a basic web server (you won't configure a web server on it yet, just provision the instance itself). We want to make the instance configuration reusable by using variables for key parameters.


Requirements:

1-Provider Configuration:

    Configure the AWS provider for your chosen region (e.g., us-east-1).
    You can hardcode the region for this first small project, but consider how you might make it a variable later.

2-Input Variables:

    Define three input variables:
        instance_type: A string variable for the EC2 instance type (e.g., t2.micro).
        ami_id: A string variable for the Amazon Machine Image (AMI) ID. For simplicity, use a common Amazon Linux 2 or Ubuntu 22.04 LTS AMI ID for us-east-1. You'll need to look up a valid AMI ID yourself.
        instance_name: A string variable for the Name tag of your EC2 instance.

3-EC2 Instance Resource:

    Create a single aws_instance resource.
    Use the input variables you defined for instance_type, ami_id, and the Name tag.


4-Outputs:

    Define an output called instance_public_ip that displays the public IP address of the deployed EC2 instance.
    Define an output called instance_id that displays the ID of the deployed EC2 instance.


5-HCL Basics & Organization:
    Create at least two .tf files:
        main.tf: For your aws_instance resource.
        variables.tf: For your variable definitions.
        (Optional but good practice) outputs.tf: For your output definitions.
    Add comments where appropriate to explain your code.
