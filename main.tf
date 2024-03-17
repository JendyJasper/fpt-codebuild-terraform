# Create S3 bucket for state file
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "fpt-codebuild-state-bucket"

  # Prevent accidental deletion of the S3 state file bucket
  lifecycle {
    prevent_destroy = true
  }
}

#add bucket version
resource "aws_s3_bucket_versioning" "fpt_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock_table" {
  name           = "fpt_codebuild_state_lock_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  # Prevent accidental deletion of the DynamoDB table
  lifecycle {
    prevent_destroy = true
  }
}



# Create S3 input bucket for the java app
# resource "aws_s3_bucket" "input-bucket" {
#   bucket = var.input-bucket
# }

# # Create S3 output bucket for the java app
# resource "aws_s3_bucket" "output-bucket" {
#   bucket = var.ouput-bucket
# }


# resource "aws_s3_object" "input-bucket-object" {
#   bucket = var.input-bucket
#   key    = "MessageUtil.zip"
#   # source = "../fpt-aws-devops/MessageUtil.zip"
#   force_destroy = true  # This allows Terraform to delete non-empty buckets
# }

