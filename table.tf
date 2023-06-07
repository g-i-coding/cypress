resource "aws_dynamodb_table" "TeAmCyPrEsS" {
  name = "CypressRaterOne"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key = "CypressRaterOneId"
  attribute {
    name = "CypressRaterOneId"
    type = "S"
  }
  tags = {
    Name = "TeamCypress"
    Purpose = "Pain"
  }

}

output "table_arn" {
  value = "${aws_dynamodb_table.TeAmCyPrEsS.*.arn}"
}