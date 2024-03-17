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

# Create S3 logs for codebuild
resource "aws_s3_bucket" "log-bucket" {
  bucket = "fpt-codebuild-logs"
}

data "aws_iam_policy_document" "codebuild-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#create for codebuild
resource "aws_iam_role" "codebuild-role" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.codebuild-assume-role.json
}


#create codebuild project
resource "aws_codebuild_project" "fpt-codebuild-java-project" {
  name          = var.codebuild-project-name
  description   = "fpt-java-codebuild-project"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "S3"
  }

  cache {
    type     = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"


  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.log-bucket.id}/fpt-codebuild-logs"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/JendyJasper/fpt-codebuild-java"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

}
