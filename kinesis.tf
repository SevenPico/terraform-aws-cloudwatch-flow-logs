module "kinesis_label" {
  source     = "registry.terraform.io/cloudposse/label/null"
  version    = "0.25.0"
  context    = module.this.context
  attributes = ["kinesis"]
  enabled    = module.this.enabled && var.enable_kinesis
}

module "subscription_filter_label" {
  source     = "registry.terraform.io/cloudposse/label/null"
  version    = "0.25.0"
  context    = module.this.context
  attributes = ["filter"]
  enabled    = module.this.enabled && var.enable_kinesis && var.enable_subscription_filter
}

resource "aws_kinesis_stream" "default" {
  #checkov:skip=CKV_AWS_43:skipping 'Ensure Kinesis Stream is securely encrypted' because it can be encrypted through variable
  #checkov:skip=CKV_AWS_185:skipping 'Ensure Kinesis Stream is encrypted by KMS using a customer managed Key (CMK)' because it can be encrypted through variable
  count               = module.kinesis_label.enabled ? 1 : 0
  name                = module.kinesis_label.id
  shard_count         = var.shard_count
  retention_period    = var.retention_period
  shard_level_metrics = var.shard_level_metrics
  encryption_type     = var.encryption_type
  kms_key_id          = var.kms_key_id
  tags                = module.kinesis_label.tags
}

resource "aws_cloudwatch_log_subscription_filter" "default" {
  count           = module.subscription_filter_label.enabled ? 1 : 0
  name            = module.subscription_filter_label.id
  log_group_name  = aws_cloudwatch_log_group.default[0].name
  filter_pattern  = var.filter_pattern
  destination_arn = aws_kinesis_stream.default[0].arn
  role_arn        = aws_iam_role.kinesis[0].arn
}
