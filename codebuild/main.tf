#create docker-build project
resource "aws_codebuild_project" "docker-build" {
  name          = var.codebuild-name
  description   = var.codebuild-description
  build_timeout = 5
  service_role  = var.codebuild-role

  artifacts {
    type = "NO_ARTIFACTS"
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
  }

  source {
    type            = "GITHUB"
    location        = var.git-location
    git_clone_depth = 1
    buildspec = var.buildspec-file

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = var.git-source-version

}


#retrieve the github personal access token secret from aws secret manager
data "aws_secretsmanager_secret" "github-pat" {
  name = "codebuild/github_pat"
}

#retrieve the github personal access token value from aws secret manager
data "aws_secretsmanager_secret_version" "github-pat-secret-version" {
  secret_id = data.aws_secretsmanager_secret.github-pat.id
}


#add github credentials for docker-build 
resource "aws_codebuild_source_credential" "docker-build" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = jsondecode(data.aws_secretsmanager_secret_version.github-pat-secret-version.secret_string)["personal-access-token_codebuild"]
}


