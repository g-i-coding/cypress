resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.TeAmCyPrEsS.name
  hash_key   = aws_dynamodb_table.TeAmCyPrEsS.hash_key

  item = <<ITEM
{
  "BookTitle": {"S": "Example Book"},
  "Rating": {"N": "5"}
}
ITEM
}

