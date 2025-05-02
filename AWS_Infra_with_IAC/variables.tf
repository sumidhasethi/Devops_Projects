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
