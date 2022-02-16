resource "aws_dynamodb_table" "table" {
  name                        = var.dynamodb_name
  read_capacity               = var.dynamodb_read_capacity
  write_capacity              = var.dynamodb_write_capacity
  hash_key                    = var.dynamodb_hash_key
  range_key                   = var.dynamodb_range_key
  stream_enabled              = var.dynamodb_stream_enabled
  stream_view_type            = var.dynamodb_stream_view_type

  attribute {
      name = "id"
      type = "S"
  }

  attribute {
      name = "name"
      type = "S"
  }

  attribute {
      name = "views"
      type = "N"
  }

  global_secondary_index {
    name               = "NameIndex"
    hash_key           = "name"
    range_key          = "views"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["id"]
  }

  tags                        = var.tags
}