# Configure S3 backend
terraform {
  backend "s3" {
    bucket         = "fpt-codebuild-state-bucket"
    key            = "fpt-codebuild/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "fpt_codebuild_state_lock_table"
  }
}