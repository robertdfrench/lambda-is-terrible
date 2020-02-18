import boto3

def connect_to_db():
    return boto3.client('dynamodb')

def generate_summary_of_visits(dbh):
    results = dbh.scan(
        TableName='counters',
        ProjectionExpression='hits'
    )
    (visits, visitors) = (0,0)
    for item in results['Items']:
        visits += int(item['hits']['N'])
        visitors += 1
    return f"This page has been viewed {visits} times by {visitors} unique visitors"

def record_new_visit(dbh, ip):
    dbh.update_item(
        TableName='counters',
        Key={'ip': {'S': ip}},
        UpdateExpression='ADD hits :one',
        ExpressionAttributeValues={':one': {'N': '1'}}
    )

def hit_counter(event, context):
    ip = event['requestContext']['identity']['sourceIp']
    record_new_visit(dbh, ip)
    summary = generate_summary_of_visits(dbh)

    return {'message': summary}

dbh = connect_to_db()
