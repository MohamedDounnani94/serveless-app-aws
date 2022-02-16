output "lambda_name" {
  value = var.lambda_file_name
}

output "lambda_arn" {
  value = join(",", aws_lambda_function.lambda_file.*.arn)
}