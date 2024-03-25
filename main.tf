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

module "iam" {
  source = "./iam/"
}

module "codebuild_dev" {
  source = "./codebuild/"
  codebuild-role = module.iam.codebuild-role-arn
  git-location = var.git-location
  buildspec-file = var.buildspec-dev
  codebuild-description = "codebuild project for the dev environment"

}

module "codebuild_prod" {
  source = "./codebuild/"
  codebuild-name = "fpt-flask-build-prod"
  codebuild-role = module.iam.codebuild-role-arn
  git-location = var.git-location
  buildspec-file = var.buildspec-prod
  codebuild-description = "codebuild project for the prod environment"

}