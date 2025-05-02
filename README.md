**AWS Infrastructure Setup Using Terraform (IaC)**

---

**Project Description**

This project sets up a secure and scalable AWS infrastructure using Terraform (IaC). It provisions a custom VPC with public and private subnets, an Internet Gateway, and a NAT Gateway. EC2 instances are deployed with proper security groups and IAM policies. The project also includes remote state management using S3 and DynamoDB for state locking. It follows AWS and Terraform best practices, making it suitable for learning, development, or production-ready deployments.

---

**Architecture Overview**
```text
+-----------------------------+
|        Terraform           |
|  (Infrastructure as Code)  |
+-------------+--------------+
              |
              v
+-----------------------------+
|      S3 Bucket (Backend)   |
|   Stores Terraform State   |
+-------------+--------------+
              |
              v
+-----------------------------+
|  DynamoDB (State Locking)  |
| Prevents Concurrent Apply  |
+-------------+--------------+
              |
              v
+-----------------------------+
|          AWS VPC           |
|     (Custom CIDR Block)    |
+-------------+--------------+
              |
   +----------+----------+
   |                     |
   v                     v
+--------+           +--------+
| Public |           | Private|
|Subnet 1|           |Subnet 1|
+--------+           +--------+
   |                     |
   |                     |
   v                     v
[EC2 Bastion]       [EC2 App Server]
   |                     |
   |                     |
   v                     |
+-----------------------------+
|     NAT Gateway (Public)    |
|  Allows Private to Access   |
|         Internet            |
+-----------------------------+
              |
              v
+-----------------------------+
|     Internet Gateway (IGW) |
|    Public Subnet Access    |
+-----------------------------+
              |
              v
+-----------------------------+
|       Public Internet      |
+-----------------------------+

```

---

**Key Components**

- Terraform: Manages the provisioning of AWS resources, ensuring a consistent and repeatable infrastructure setup. It automates the creation of VPCs, subnets, EC2 instances, and state management.

- AWS VPC (Virtual Private Cloud): A secure and isolated network environment within AWS, consisting of public and private subnets. It provides the foundation for all resources.

- EC2 Instances: Deployed in public and private subnets for different purposes. Public EC2 instances can be accessed from the internet, while private instances are secured behind the NAT Gateway.

- NAT Gateway: Enables private EC2 instances to access the internet for updates or communication while keeping them secure and not directly exposed to the public internet.

- Internet Gateway (IGW): Provides internet access to public subnets by routing traffic to/from the internet.

- AWS S3 Bucket: Used for storing Terraform state files, ensuring state consistency and enabling remote state locking. Can also be configured for static website hosting in certain setups.

- DynamoDB: Utilized for state locking, preventing concurrent changes to the Terraform state file and ensuring only one operation occurs at a time.

- IAM Policies & Roles: Defines and enforces the permissions for access to AWS resources, ensuring least-privilege access.
<br><br>
---

**Prerequisites**

- Install and configure the AWS Command Line Interface (CLI). Run aws configure to set your AWS Access Key, Secret Key, region, and output format.
- Familiarity with Terraform and the principles of Infrastructure as Code (IaC).
- Familiarity with AWS services like EC2, VPC, IAM, and S3. Basic understanding of Terraform syntax and commands (e.g., terraform init, terraform apply).
  
---

**Project Structure**

<img width="545" alt="Screenshot 2025-05-02 at 9 57 26 AM" src="https://github.com/user-attachments/assets/8d92ef8e-81c8-4757-bac9-a4c98819b061" />

---

**Steps**

---

**Step 1:** 

**Set Up Your Development Environment**

Begin by installing Terraform and the AWS Command Line Interface (CLI) on your local machine. Next, configure your AWS credentials by running the command aws configure, and input your AWS access key and secret key when prompted.
<br><br>

**Step 2:**

**S3 Bucket and DynamoDB Table for Remote State**

1. **S3 Bucket**: Terraform will store the state file in this bucket. The bucket should be globally unique.
2. **DynamoDB Table**: This table will be used for state locking to prevent concurrent changes.

Before provisioning the infrastructure, create the remote state resources (S3 bucket and DynamoDB table) that Terraform will use to store the state file and lock the state during deployment.
<br><br>

**Create S3 Bucket**

Run the following AWS CLI command to create an S3 bucket for remote state storage:

    aws s3 mb s3://aws-infrabucket101 --region us-east-1



- Replace aws-infrabucket101 with a globally unique name for the bucket.

- Change us-east-1 to your preferred region.
<br><br>

**Create DynamoDB Table**

To create a DynamoDB table for state locking, run the following command:


        aws dynamodb create-table \
            --table-name terraform-lock-table \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode PAY_PER_REQUEST \
            --region us-east-1


This will create the DynamoDB table named terraform-lock-table. Change the region (us-east-1) & table name to the one of your choice.


Once these two resources are created, proceed with configuring your Terraform remote backend to use the S3 bucket and DynamoDB table for state management.
<br><br>

**Why Create S3 and DynamoDB First?**


Creating the S3 bucket and DynamoDB table before provisioning other resources is essential for remote state management in Terraform. The S3 bucket stores the Terraform state file remotely, while DynamoDB provides state locking to prevent concurrent changes. These resources must exist before running terraform init to configure the backend. Without them, Terraform cannot initialize remote state storage, leading to errors during infrastructure deployment.

While you can define the S3 bucket and DynamoDB table within the same Terraform configuration, they must be created first before applying other resources. If you try to create them together, Terraform will attempt to use them for state management during the terraform apply process before they exist, leading to errors. It’s essential to create and configure them beforehand to ensure proper remote state management and locking.
<br><br>


**Step 3:**

**Configure Terraform Backend**

Create a backend.tf file to configure the remote backend in Terraform. This ensures that Terraform will store its state in the S3 bucket and use the DynamoDB table for state locking.

    
    
      terraform {
        backend "s3" {
          bucket         = "aws-infrabucket101"  # Replace with your S3 bucket name
          key            = "aws/terraform.tfstate"
          region         = "us-east-1"  # Choose your AWS region
          encrypt        = true
          dynamodb_table = "terraform-lock-table"  # Replace with your DynamoDB table name for  state locking
        }
      }




**Step 4:**

**Initialize Terraform**

Run terraform init to initialize the configuration and set up the remote backend. This will configure the backend to use the S3 bucket for state storage and DynamoDB for state locking.

    terraform init


**Step 5:**

**Define Infrastructure Resources**

Once backend is initialised, define the AWS infrastructure in main.tf file. 


1. Provider Block

        provider "aws" {
          region = var.aws_region
        }

This specifies that AWS is the cloud provider and sets the region to us-east-1 for resource provisioning.


2. VPC Creation
      
            resource "aws_vpc" "main" {
              cidr_block = var.vpc_cidr_block
              tags = {
                Name = "main-vpc"
              }
            }

This block creates a Virtual Private Cloud (VPC) in AWS with the CIDR block 10.0.0.0/16, allowing up to 65,536 IP addresses. The tags section assigns a human-readable name (main-vpc) to help identify the VPC in the AWS console.



3. Internet Gateway

      
            resource "aws_internet_gateway" "igw" {
              vpc_id = aws_vpc.main.id
              tags = {
                Name = "main-igw"
              }
            }


This block creates an Internet Gateway and attaches it to the VPC created earlier 


4. Public Subnet & Private Subnet

        resource "aws_subnet" "public" {
          vpc_id            = aws_vpc.main.id
          cidr_block        = var.public_subnet_cidr_block
          map_public_ip_on_launch = true
          availability_zone = var.availability_zone
        
          tags = {
            Name = "public-subnet"
          }
        }
        
       
        resource "aws_subnet" "private" {
          vpc_id            = aws_vpc.main.id
          cidr_block        = var.private_subnet_cidr_block
          availability_zone = var.availability_zone
        
          tags = {
            Name = "private-subnet"
          }
        }



Both subnets are created within the same VPC, ensuring that they can communicate with each other if required. The public subnet will have access to the internet, while the private subnet will rely on resources like a NAT Gateway for internet connectivity.


5. Public Route Table (For Public Subnet)

        resource "aws_route_table" "public_rt" {
          vpc_id = aws_vpc.main.id
          route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw.id
          }
          tags = {
            Name = "public-rt"
          }
        }

The route table defines how traffic should be routed within the VPC.



6. Route Table Association (For Public Subnet)
        
        resource "aws_route_table_association" "public_assoc" {
          subnet_id      = aws_subnet.public.id
          route_table_id = aws_route_table.public_rt.id
        }

After creating the route table, we need to associate it with the public subnet so that it knows how to route traffic.



7. Elastic IP for NAT Gateway
        
        resource "aws_eip" "nat_eip" {
          domain = var.eip_domain
        }

The aws_eip resource is used to allocate an Elastic IP (EIP) in AWS. The Elastic IP is necessary for the NAT Gateway (which enables private subnet resources to access the internet) to have a persistent, public-facing IP address.


8. NAT Gateway Creation
             
          resource "aws_nat_gateway" "nat" {
            allocation_id = aws_eip.nat_eip.id
            subnet_id     = aws_subnet.public.id
            tags = {
              Name = "nat-gateway"
            }
          }

This block defines the NAT Gateway resource used to enable instances in private subnets to access the internet, while ensuring that those instances remain shielded from direct inbound traffic.



9. Private Route Table (For Private Subnet)
        
        resource "aws_route_table" "private_rt" {
          vpc_id = aws_vpc.main.id
        
          route {
            cidr_block     = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.nat.id
          }
        
          tags = {
            Name = "private-rt"
          }
        }

The aws_route_table resource defines the route table for the private subnet, enabling outbound internet access through the NAT Gateway.


11. Route Table Association (For Private Subnet)
        
        resource "aws_route_table_association" "private_assoc" {
          subnet_id      = aws_subnet.private.id
          route_table_id = aws_route_table.private_rt.id
        }

This resource essentially applies the route table (private_rt) to the private subnet (private), ensuring that the routing logic defined in private_rt is used by all instances and resources within that subnet.


12. Security Group for SSH and HTTP Access
          
          
          resource "aws_security_group" "allow_http_ssh" {
            name        = "allow-http-ssh"
            description = "Allow HTTP and SSH inbound"
            vpc_id      = aws_vpc.main.id
          
            ingress {
              from_port   = 22
              to_port     = 22
              protocol    = "tcp"
              cidr_blocks = [var.ssh_ip]  # SSH IP
            }
          
            ingress {
              from_port   = 80
              to_port     = 80
              protocol    = "tcp"
              cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
            }
          
            egress {
              from_port   = 0
              to_port     = 0
              protocol    = "-1"
              cidr_blocks = ["0.0.0.0/0"]
            }
          
            tags = {
              Name = "allow-http-ssh"
            }
          }
                  

This resource creates an AWS Security Group to control inbound and outbound traffic for EC2 instances. Inbound Rules Allows SSH (port 22) from a specific IP address (replace with your IP) and HTTP (port 80) from any IP address, enabling public website access. Outbound Rule allows all outbound traffic.


13. Public EC2 Instance (Accessible via SSH and Hosting Website)
        
        resource "aws_instance" "public_ec2" {
          ami                         = var.ami_id
          instance_type               = var.instance_type
          subnet_id                   = aws_subnet.public.id
          vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]
          associate_public_ip_address = true
          key_name                    = var.key_name  # Key name
        
          # User data to install Apache web server and host a simple website
          user_data = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install -y httpd
                      systemctl start httpd
                      systemctl enable httpd
                      echo "Hello, World! This is a sample website." > /var/www/html/index.html
                      EOF
        
          tags = {
            Name = "public-instance"
          }
        }


This block creates an EC2 instance in AWS and it will serve a basic web application accessible via HTTP and SSH.


ami: Specifies the Amazon Machine Image (AMI) to use, in this case, Amazon Linux 2 for us-east-1.

instance_type: Defines the EC2 instance type (here, t2.micro).

subnet_id: Associates the EC2 instance with the public subnet (aws_subnet.public.id).

vpc_security_group_ids: Assigns the security group that allows SSH and HTTP traffic.

associate_public_ip_address: Ensures the EC2 instance gets a public IP for internet access.

key_name: Specifies the key pair for SSH access (new-key).

user_data: Provides a script to install Apache web server on startup and host a simple HTML page (Hello, World!).

tags: Adds a tag to the instance with the name public-instance.


14. Private EC2 Instance (Accessible via SSH)

          resource "aws_instance" "private_ec2" {
            ami                         = var.ami_id
            instance_type               = var.instance_type
            subnet_id                   = aws_subnet.private.id
            vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]
            key_name                    = var.key_name  # Key name
          
            tags = {
              Name = "private-instance"
            }
          }


This block creates a private EC2 instance in a private subnet using an Amazon Linux 2 AMI, with SSH access via a specified security group and a custom key pair for access.


**Step 6:**

**Define the values for variables**

Create a variable.tf file and define all the input variables required to customize and provision AWS infrastructure. 


              
              variable "aws_region" {
                description = "The AWS region to deploy resources"
                default     = "us-east-1"  # Default region, can be overridden
              }
              
              variable "vpc_cidr_block" {
                description = "The CIDR block for the VPC"
                default     = "10.0.0.0/16"
              }
              
              variable "public_subnet_cidr_block" {
                description = "The CIDR block for the public subnet"
                default     = "10.0.1.0/24"
              }
              
              variable "private_subnet_cidr_block" {
                description = "The CIDR block for the private subnet"
                default     = "10.0.2.0/24"
              }
              
              variable "ssh_ip" {
                description = "The IP address allowed for SSH access"
                default     = "0.0.0.0/0"  # Replace with your IP for SSH access
              }
              
              variable "ami_id" {
                description = "The AMI ID to use for the EC2 instance"
                default     = "ami-0f88e80871fd81e91"  # Replace with your AMI ID
              }
              
              variable "instance_type" {
                description = "The EC2 instance type"
                default     = "t2.micro"
              }
              
              variable "key_name" {
                description = "The SSH key pair to use for EC2 instances"
                default     = "new-key"  # Replace with your SSH key name
              }
              
              variable "eip_domain" {
                description = "The domain for the Elastic IP"
                default     = "vpc"
              }
              
              variable "availability_zone" {
                description = "The availability zone for the subnets"
                default     = "us-east-1a"  # Modify based on your region
              }


**Step 7:**

**Create the Output file**

In terraform, output.tf declares the key output values (like instance IPs or resource IDs) to display after execution, making it easier to access important resource information.

          output "vpc_id" {
            description = "The ID of the VPC"
            value       = aws_vpc.main.id
          }
          
          output "public_subnet_id" {
            description = "The ID of the public subnet"
            value       = aws_subnet.public.id
          }
          
          output "private_subnet_id" {
            description = "The ID of the private subnet"
            value       = aws_subnet.private.id
          }
          
          output "public_instance_public_ip" {
            description = "The public IP of the EC2 instance"
            value       = aws_instance.public_ec2.public_ip
          }


This output.tf file will provide the following key information after running terraform apply:

vpc_id – The unique identifier of the created VPC. Useful for referencing or debugging.

public_subnet_id – The ID of the public subnet within the VPC.

private_subnet_id – The ID of the private subnet within the VPC.

public_instance_public_ip – The public IP address of the EC2 instance launched in the public subnet (so you can SSH or access the web server).


**Step 8:**

**Preview the planned infrastructure changes**

Run the plan command to preview the resources that will be created.

      terraform plan


**Step 9:**

**Apply the Configuration**

Apply the configuration to provision infrastructure:

      terraform apply  -auto-approve

Once done, it will create the resources and give the values in the terminal as output.


<img width="499" alt="Screenshot 2025-05-02 at 5 27 34 PM" src="https://github.com/user-attachments/assets/bff9e8fe-2f05-4f5b-815d-d80991cc0b23" />



**Step 10**

**Validation**

- Check in the AWS Console or use CLI to check the resources:
EC2

<img width="918" alt="Screenshot 2025-05-02 at 5 28 34 PM" src="https://github.com/user-attachments/assets/73b4534d-0779-46c1-8966-b46146bb26e2" />

VPC
  
<img width="919" alt="Screenshot 2025-05-02 at 5 29 05 PM" src="https://github.com/user-attachments/assets/780451f2-2327-432a-ba86-e37817bdb01c" />


- Confirm Terraform State

Check if Terraform is aware of the infra:

      terraform state list

It should list all provisioned resources.



<img width="580" alt="Screenshot 2025-05-02 at 5 32 56 PM" src="https://github.com/user-attachments/assets/1606fdce-6143-450d-a20d-b7e956c9ffdf" />


- Test EC2 Public Instance (via SSH)


Use the public_instance_public_ip to connect:

ssh -i <your-key.pem> ec2-user@54.175.7.101

<img width="653" alt="Screenshot 2025-05-02 at 5 48 51 PM" src="https://github.com/user-attachments/assets/2ba61012-6807-47e5-939b-d306c3f25f18" />

Check if the httpd service is running correctly.

<img width="628" alt="Screenshot 2025-05-02 at 5 52 11 PM" src="https://github.com/user-attachments/assets/d2e7d8ab-ef95-4a49-baad-80b99b082a45" />


**Make sure:**

Your key pair matches the one used in Terraform.

Security group allows inbound SSH (port 22) from your IP or from all IPs.

If SSH works, your EC2 + public subnet + SG + key setup is working.


- Check if Web Server is Serving the Page

Open a browser and type http://<Public IP>

You should see the message: "Hello, World! This is a sample website.".

This confirms that your user_data script ran successfully, installing and starting the httpd server and serving the sample webpage.

<img width="716" alt="Screenshot 2025-05-02 at 5 54 20 PM" src="https://github.com/user-attachments/assets/661a1576-4635-4450-8440-cd1f53e7bc8b" />



**Key Learnings**

- Learned to use Terraform for provisioning VPC, EC2 instances, subnets, and security groups to create a scalable cloud infrastructure.

- Configured S3 and DynamoDB for secure state management and locking, ensuring safe collaboration and preventing state conflicts.

- Accessed the deployed EC2 instance via its public IP, confirming successful web server setup and full infrastructure provisioning.

- Used EC2 user data scripts to automatically install and configure a web server, displaying a sample webpage. This showcases 
   infrastructure automation using Terraform.
