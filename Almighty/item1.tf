resource "aws_dynamodb_table_item" "item1" {
  depends_on = [aws_dynamodb_table.TeAmCyPrEsS]

  table_name = aws_dynamodb_table.TeAmCyPrEsS.name
  hash_key   = aws_dynamodb_table.TeAmCyPrEsS.hash_key

  item = jsonencode({
    "CypressRaterOneId"        = { "S": "001" }
    "CypressRaterOneGrade"     = { "N": "98" }
    "CypressRaterOneFirstName" = { "S": "Carlos" }
    "CypressRaterOneLastName"  = { "S": "Garcia" }
  })
}
