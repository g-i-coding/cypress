import json
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('CypressRaterOne')

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def format_items(items):
    formatted_items = []
    for item in items:
        formatted_items.append({"book": item["BookTitle"].replace('_', ' '), "Rating": float(item["Rating"])})
    return formatted_items

def lambda_handler(event, context):
    response_headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials' : True,
        'Content-Type': 'application/json'
    }
    
    try:
        if event['httpMethod'] == 'POST':
            body = json.loads(event['body'])
            rating_id = str(uuid.uuid4())
            table.put_item(Item={'BookTitle': body['book'], 'Rating': Decimal(body['rating']), 'RatingId': rating_id})
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
