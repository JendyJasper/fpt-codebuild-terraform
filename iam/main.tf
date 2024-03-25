
#retrieve iam policy for codebuild
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

#create iam role for codebuild
resource "aws_iam_role" "codebuild-role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild-assume-role.json

}

# IAM policy to grant CloudWatch Logs permissions
data "aws_iam_policy_document" "codebuild-cloudwatch-policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["arn:aws:logs:*:*:log-group:/aws/codebuild/*"]
  }
}

# Attach IAM policy to the CodeBuild role
resource "aws_iam_role_policy_attachment" "codebuild-cloudwatch-attachment" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess" # or specify your custom policy ARN
}

