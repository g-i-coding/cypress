resource "aws_dynamodb_table" "TeAmCyPrEsS" {
  name = "CypressRaterOne"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key = "BookTitle"
  range_key = "RatingId"  # Add this line to specify a sort key

  attribute {
    name = "BookTitle"
    type = "S"
  }

  attribute {
    name = "Rating"
    type = "N"
  }
  
  attribute {
    name = "RatingId"   # Add this attribute for sort key
    type = "S"
  }

global_secondary_index {
    name            = "RatingIndex"
    hash_key        = "Rating"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }
  
}

data "aws_dynamodb_table" "TeAmCyPrEsS" {
  name = aws_dynamodb_table.TeAmCyPrEsS.name
}