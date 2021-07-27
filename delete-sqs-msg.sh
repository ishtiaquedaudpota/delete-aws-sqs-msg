#!/bin/bash
## Description: The script will scan sqs message and search for given pattern,
## If the given pattern is found in a message, then it will prompt to delete the message.
## If no pattern found within 10 seconds, then the script will exit

if [[ $# != 2 ]]; then echo "Usage: $0 region queue pattern"; exit 1; fi

REGION=$1
QUEUE=$2
PATTERN=$3
TIMEOUT=1
until [[ ${TIMEOUT} -eq 10 ]]; do
  MESSAGE=$(aws sqs receive-message --region ${REGION} --queue-url https://sqs.${REGION}.amazonaws.com/${QUEUE})
  if echo ${MESSAGE} | grep -q ${PATTERN}; then
    echo ${MESSAGE} | jq -r '.Messages[] | "Id: " + .MessageId + "\nMessage: " + .Body + "\nReceiptHandle: " + .ReceiptHandle'
    read -p "Delete the message (y/n)? " -n 1 -r
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      aws sqs delete-message --region ${REGION} --queue-url https://sqs.${REGION}.amazonaws.com/${QUEUE} --receipt-handle $(jq -r '.Messages[].ReceiptHandle' <<< "${MESSAGE}")

      if [[ $? -eq 0 ]]; then echo "SUCCESS"; else echo "FAILED"; fi
    fi

    exit 0
  fi
  TIMEOUT=$((TIMEOUT+1))
done

if [[ -z ${MESSAGE} ]]; then echo "ERROR: ${PATTERN} not found in any of SQS messages!" && exit 1; fi
