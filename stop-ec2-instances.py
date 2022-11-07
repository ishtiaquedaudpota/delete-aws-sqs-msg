import boto3

ec2 = boto3.client('ec2', region_name='us-east-1')

def lambda_handler(event, context):
    instance_ids = []
    response = ec2.describe_instances()
    instances_full_details = response['Reservations']
    for instance_detail in instances_full_details:
        group_instances = instance_detail['Instances']
        for instance in group_instances:
            instance_id = instance['InstanceId']
            instance_ids.append(instance_id)
            
    ec2.stop_instances(InstanceIds=instance_ids)
    print(f'Stopped instances: {instance_ids}')
