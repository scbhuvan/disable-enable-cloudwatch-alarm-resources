import boto3  
import json
import os

def lambda_handler(event, context):
    client = boto3.client('cloudwatch')
    action = event.get('action')
   
    # Reading alarm names from environment variable
    try:
        alarm_names = json.loads(os.environ.get('ALARM_NAMES', '[]'))
    except json.JSONDecodeError:
        alarm_names = []
    
    if action == 'enable':
        for alarm_name in alarm_names:
            client.enable_alarm_actions(AlarmNames=[alarm_name])
    elif action == 'disable':
        for alarm_name in alarm_names:
            client.disable_alarm_actions(AlarmNames=[alarm_name])


    