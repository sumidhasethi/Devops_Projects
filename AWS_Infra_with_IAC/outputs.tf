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
