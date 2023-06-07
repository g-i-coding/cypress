import json
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cypress-table')

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def format_items(items):
    formatted_items = []
    for item in items:
        formatted_items.append({"book": item["ID"].replace('_', ' '), "rating": float(item["rating"])})
    return formatted_items

def lambda_handler(event, context):
    response_headers = {
        'Access-Control-Allow-Origin': '*', 
        'Content-Type': 'application/json'
    }
    
    try:
        if event['httpMethod'] == 'POST':
            body = json.loads(event['body'])
            table.put_item(Item={'ID': body['book'], 'rating': Decimal(body['rating'])})
            return {
                'statusCode': 200,
                'headers': response_headers,
                'body': json.dumps({'message': 'Rating saved successfully'})
            }
        elif event['httpMethod'] == 'GET':
            response = table.scan()
            return {
                'statusCode': 200,
                'headers': response_headers,
                'body': json.dumps(format_items(response['Items']), default=decimal_default)
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': response_headers,
            'body': json.dumps({'message': 'Error saving rating', 'error': str(e)})
        }
