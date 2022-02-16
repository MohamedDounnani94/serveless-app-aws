variable "tags" {
  type = map
  description = "Tags for lambda"
  default = {}
}

variable "dynamodb_name" {
  description = "Table name"
}

variable "dynamodb_read_capacity" {
  description = "Table read capacity"
}

variable "dynamodb_write_capacity" {
  description = "Table write capacity"
}

variable "dynamodb_hash_key" {
  description = "Table hask key"
}

variable "dynamodb_range_key" {
  description = "Table range key"
}

variable "dynamodb_stream_enabled" {
  description = "Table stream enabled"
}

variable "dynamodb_stream_view_type" {
  description = "Table stream view type"
}