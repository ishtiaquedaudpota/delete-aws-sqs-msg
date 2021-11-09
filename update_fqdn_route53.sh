#!/bin/bash
## Description: Copy the script into /var/lib/cloud/scripts/per-boot/update_fqdn_route53.sh
## Reference: https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o

# Get hostname
HOSTNAME=`hostname`

# Update Route 53 recordset only for golden ec2 instances
if [[ $HOSTNAME == *gold* ]]; then
  # Get public ip
  PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)

  # Update public ip in route 53
  aws route53 change-resource-record-sets --hosted-zone-id ABCD1234 --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$HOSTNAME'.example.com","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$PUBLIC_IP'"}]}}]}'
fi
