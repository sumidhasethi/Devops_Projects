 provider "aws" {
   region = var.aws_region
 }

  resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name = "main-vpc"
       }
  }

 resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.main.id
   tags = {
         Name = "main-igw"
       }
     }

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


  resource "aws_route_table_association" "public_assoc" {
   subnet_id      = aws_subnet.public.id
   route_table_id = aws_route_table.public_rt.id
 }


  resource "aws_eip" "nat_eip" {
   domain = var.eip_domain
 }


    resource "aws_nat_gateway" "nat" {
     allocation_id = aws_eip.nat_eip.id
     subnet_id     = aws_subnet.public.id
     tags = {
       Name = "nat-gateway"
     }
   }



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


resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}



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

