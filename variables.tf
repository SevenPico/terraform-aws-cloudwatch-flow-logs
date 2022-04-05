
variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "enable_kinesis" {
  description = "Creates a kinesis stream for the logged events."
  type        = bool
  default     = false
}

variable "enable_subscription_filter" {
  description = "Creates a subscription filter for then kinesis stream."
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "Number of days you want to retain log events in the log group"
  type        = number
  default     = "30"
}

variable "traffic_type" {
  description = "Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of subnets"
  type        = list(string)
  default     = []
}

variable "eni_ids" {
  description = "IDs of ENIs"
  type        = list(string)
  default     = []
}

variable "log_format" {
  type        = string
  description = "(Optional) The fields to include in the flow log record, in the order in which they should appear."
  default     = null
}

variable "log_group_name" {
  type        = string
  description = "The name of the log group displayed in Cloudwatch Logs.  If not supplied, the value is determined from the Label Context."
  default     = null
}

variable "max_aggregation_interval" {
  type        = number
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: 60 seconds (1 minute) or 600 seconds (10 minutes)."
  default     = 600
}

variable "shard_count" {
  description = "Number of shards that the stream will use"
  type        = number
  default     = "1"
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream"
  type        = number
  default     = "48"
}

variable "shard_level_metrics" {
  description = "List of shard-level CloudWatch metrics which can be enabled for the stream"
  type        = list(string)
  default = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

variable "encryption_type" {
  description = "GUID for the customer-managed KMS key to use for encryption. The only acceptable values are NONE or KMS"
  default     = "NONE"
}

variable "filter_pattern" {
  description = "Valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events"
  type        = string
  default     = "[version, account, eni, source, destination, srcport, destport, protocol, packets, bytes, windowstart, windowend, action, flowlogstatus]"
}

variable "kms_key_id" {
  description = "ID of KMS key"
  type        = string
  default     = ""
}

