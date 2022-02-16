terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

locals {
  lambda_get = "get-tasks"
  lambda_post = "post-task"
  region = "eu-central-1"
}

provider "aws" {
  profile = "default"
  region  = local.region
}

module "lambda-get" {
  source                                = "./modules/lambda"

  region                                = local.region
  lambda_function_name                  = local.lambda_get
  lambda_runtime                        = "nodejs12.x"
  lambda_handler                        = "index.handler"
  lambda_file_name                      = "lambda-get.zip"
  lambda_description                    = "REST API to retrieve all tasks in dynamodb"

  lambda_role                           = module.iam-get.lambda_role_arn
}

module "lambda-post" {
  source                                = "./modules/lambda"

  region                                = local.region
  lambda_function_name                  = local.lambda_post
  lambda_runtime                        = "nodejs12.x"
  lambda_handler                        = "index.handler"
  lambda_file_name                      = "lambda-post.zip"
  lambda_description                    = "REST API to insert a task in dynamodb"

  lambda_role                           = module.iam-post.lambda_role_arn
  
}

module "apigw-post" {
  source                                = "./modules/api-gateway"

  api_gw_name                           = "post-task-api-gateway"
  api_gw_endpoint_configuration_type    = "REGIONAL"
  stage_name                            = terraform.workspace
  method                                = "POST"
  lambda_arn                            = module.lambda-post.lambda_arn
  region                                = local.region
  lambda_name                           = local.lambda_post
  lambda_api_key_required               = true
}

module "apigw-get" {
  source                                = "./modules/api-gateway"

  api_gw_name                           = "get-tasks-api-gateway"
  api_gw_endpoint_configuration_type    = "REGIONAL"
  stage_name                            = terraform.workspace
  method                                = "GET"
  lambda_arn                            = module.lambda-get.lambda_arn
  region                                = local.region
  lambda_name                           = local.lambda_get
}

module "dynamodb" {
  source                                = "./modules/dynamodb"
  dynamodb_name                         = "tasks"
  dynamodb_read_capacity                = 20
  dynamodb_write_capacity               = 20
  dynamodb_hash_key                     = "id"
  dynamodb_range_key                    = ""
  dynamodb_stream_enabled               = "true"
  dynamodb_stream_view_type             = "NEW_IMAGE"
}

module "iam-post" {
  source = "./modules/iam"

  lambda_name                           = local.lambda_post
  api_gw_name                           = module.apigw-post.api_gw_name
  api_gw_id                             = module.apigw-post.api_gw_id
  dynamodb_policy_action_list           = ["dynamodb:PutItem"]
  dynamodb_tables_count                 = 1
}

module "iam-get" {
  source = "./modules/iam"

  lambda_name                           = local.lambda_get
  api_gw_name                           = module.apigw-get.api_gw_name
  api_gw_id                             = module.apigw-get.api_gw_id
  dynamodb_policy_action_list           = ["dynamodb:Scan"]
  dynamodb_tables_count                 = 1
}