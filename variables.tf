variable "region" {
  default = "us-east-1"
}

variable "input-bucket" {
  default = "codebuild-us-east-1-571207880192-input-buucket"
}

variable "ouput-bucket" {
  default = "codebuild-us-east-1-571207880192-output-buucket"
}

variable "codebuild-project-name" {
  default = "fpt-java-codebuild"
}