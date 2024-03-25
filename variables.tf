variable "region" {
  default = "us-east-1"
}

variable "git-location" {
  default = "https://github.com/JendyJasper/fpt-flask-app-spec-files.git"
}

variable "buildspec" {
  type = map(string)
  default = {
    "prod" : "buildspec_prod.yml"
    "dev" : "buildspec_dev.yml"
  }
}


variable "codebuild-name" {
  type = map(string)
  default = {
    "prod" : "codebuild-prod"
    "dev" : "codebuild-dev"
  }
}

variable "repository-name" {
  type = map(string)
  default = {
    "prod" : "fpt-prod"
    "dev" : "fpt-dev"
  }
}