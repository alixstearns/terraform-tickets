## create a terraform bucket
##aws s3api create-bucket --bucket my-terraform-state-bucket --region us-east-1
##aws s3api put-bucket-versioning --bucket my-terraform-state-bucket --versioning-configuration Status=Enabled


terraform {
  backend "s3" {
    bucket  = "s3alix-bucket"
    key     = "terraform-tickets/terraform.tfstate" # Optional: Use a unique key path
    region  = "us-east-1"
    encrypt = true

  }
}


resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"  # You can also use "PROVISIONED" if needed
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  ttl {
    attribute_name = "LockID"
    enabled        = true
  }
}

# Output the ARN of the DynamoDB table for reference
output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_lock.arn
}

