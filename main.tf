data "aws_region" "default" {}

resource "aws_cloudwatch_log_group" "default" {
  count             = module.this.enabled ? 1 : 0
  name              = var.log_group_name != null ? var.log_group_name : module.this.id
  retention_in_days = var.retention_in_days
  tags              = module.this.tags
}

resource "aws_flow_log" "vpc" {
  count                    = module.this.enabled ? 1 : 0
  log_destination          = aws_cloudwatch_log_group.default[0].arn
  iam_role_arn             = aws_iam_role.log[0].arn
  log_format               = var.log_format
  max_aggregation_interval = var.max_aggregation_interval
  vpc_id                   = var.vpc_id
  traffic_type             = var.traffic_type
  tags                     = module.this.tags
}

resource "aws_flow_log" "subnets" {
  count                    = module.this.enabled ? length(compact(var.subnet_ids)) : 0
  log_destination          = aws_cloudwatch_log_group.default[0].arn
  iam_role_arn             = aws_iam_role.log[0].arn
  log_format               = var.log_format
  max_aggregation_interval = var.max_aggregation_interval
  subnet_id                = element(compact(var.subnet_ids), count.index)
  traffic_type             = var.traffic_type
  tags                     = module.this.tags
}

resource "aws_flow_log" "eni" {
  count                    = module.this.enabled ? length(compact(var.eni_ids)) : 0
  log_destination          = aws_cloudwatch_log_group.default[0].arn
  iam_role_arn             = aws_iam_role.log[0].arn
  log_format               = var.log_format
  max_aggregation_interval = var.max_aggregation_interval
  subnet_id                = element(compact(var.eni_ids), count.index)
  traffic_type             = var.traffic_type
  tags                     = module.this.tags
}
