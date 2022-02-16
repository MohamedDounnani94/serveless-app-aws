variable "tags" {
  type = map
  description = "Tags for lambda"
  default = {}
}

variable "region" {
  description = "Region of Lambda & S3 source code"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
}

variable "lambda_description" {
  description = "Lambda description"
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda to create"
}

variable "lambda_handler" {
  description = "The name of Lambda function handler"
}

variable "lambda_role" {
  description = "IAM role attached to Lambda function - ARN"
}

variable "lambda_timeout" {
  description = "Maximum runtime for Lambda"
  default = 30
}

variable "lambda_file_name" {
  description = "Path to lambda code zip"
}

variable "lambda_memory_size" {
  description = "Lambda memory size"
  default = 128
}

variable "lambda_vpc_security_group_ids" {
  description = "Lambda VPC Security Group IDs"
  type = list(string)
  default = []
}

variable "lambda_vpc_subnet_ids" {
  description = "Lambda VPC Subnet IDs"
  type = list(string)
  default = []
}

variable "lambda_layers" {
  description = "Lambda Layer ARNS"
  type = list(string)
  default = []
}
