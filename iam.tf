module "log_role_label" {
  source     = "registry.terraform.io/cloudposse/label/null"
  version    = "0.25.0"
  context    = module.this.context
  attributes = ["role"]
}

module "kinesis_role_label" {
  source     = "registry.terraform.io/cloudposse/label/null"
  version    = "0.25.0"
  context    = module.kinesis_label.context
  attributes = ["kinesis"]
}

data "aws_iam_policy_document" "log_assume" {
  count = module.log_role_label.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "log" {
  count = module.log_role_label.enabled ? 1 : 0
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "log" {
  count  = module.log_role_label.enabled ? 1 : 0
  name   = "${module.log_role_label.id}-policy"
  role   = aws_iam_role.log[0].id
  policy = data.aws_iam_policy_document.log[0].json
}

resource "aws_iam_role" "log" {
  count              = module.log_role_label.enabled ? 1 : 0
  name               = module.log_role_label.id
  assume_role_policy = data.aws_iam_policy_document.log_assume[0].json
  tags               = module.log_role_label.tags
}

data "aws_iam_policy_document" "kinesis_assume" {
  count = module.kinesis_role_label.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["logs.${length(var.region) > 0 ? var.region : data.aws_region.default.name}.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kinesis" {
  count = module.kinesis_role_label.enabled ? 1 : 0
  statement {
    actions = [
      "kinesis:PutRecord*",
      "kinesis:DescribeStream",
      "kinesis:ListStreams",
    ]

    resources = [
      aws_kinesis_stream.default[0].arn,
    ]
  }
}

resource "aws_iam_role" "kinesis" {
  count = module.kinesis_role_label.enabled ? 1 : 0
  name               = module.kinesis_role_label.id
  assume_role_policy = data.aws_iam_policy_document.kinesis_assume[0].json
}

resource "aws_iam_role_policy" "kinesis" {
  count  = module.kinesis_role_label.enabled ? 1 : 0
  name   = "${module.kinesis_role_label.id}-policy"
  role   = aws_iam_role.kinesis[0].id
  policy = data.aws_iam_policy_document.kinesis[0].json
}
