variable "codebuild-name" {
  default = "fpt-flask-build-dev"
}


variable "git-location" {
  default = "https://github.com/JendyJasper/fpt-flask-app-spec-files.git"
}

variable "buildspec-file" {
  default = "buildspec-dev.yml"
}

variable "codebuild-description" {
  default = "codebuil project for the dev environment"
}

variable "git-source-version" {
  default = "main"
}

variable "codebuild-role" {
  
}