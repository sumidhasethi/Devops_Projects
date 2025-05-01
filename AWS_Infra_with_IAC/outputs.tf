output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_instance_ip" {
  value = aws_instance.public_ec2.public_ip
}

