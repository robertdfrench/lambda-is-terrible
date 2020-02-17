import boto3

def connect_to_db():
    return boto3.client('dynamodb')

def generate_summary_of_visits(dbh):
    (visits, visitors) = (0,0)
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

    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)
    return [summary.encode('utf-8')]

dbh = connect_to_db()
