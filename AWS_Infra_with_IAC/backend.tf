terraform {
  backend "s3" {
    bucket         = "aws-infrabucket101"       # Replace with your actual bucket
    key            = "aws-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"             # Replace with your lock table
    encrypt        = true
  }
}

