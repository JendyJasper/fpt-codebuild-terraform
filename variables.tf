variable "region" {
  default = "us-east-1"
}

variable "git-location" {
  default = "https://github.com/JendyJasper/fpt-flask-app-spec-files.git"
}

variable "buildspec-dev" {
  default = "buildspec_dev.yml"
}

variable "buildspec-prod" {
  default = "buildspec_prod.yml"
}

variable "codebuild-name" {
  default = "codebuild-dev"
}