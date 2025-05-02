  terraform {
    backend "s3" {
      bucket         = "aws-infrabucket101"  # Replace with your S3 bucket name
      key            = "aws/terraform.tfstate"
      region         = "us-east-1"  # Choose your AWS region
      encrypt        = true
      dynamodb_table = "terraform-lock-table"  # Replace with your DynamoDB table name for  state locking
    }
  }
