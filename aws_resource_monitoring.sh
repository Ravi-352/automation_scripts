#!/bin/bash

##############################
# Author: Ravi Kiran
# Date: 16th Aug 2023
# Version: v1
# This script will report the AWS resource usage
##############################

# Resources being tracked

# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM Users
##############################

# AWS Commands reference: https://docs.aws.amazon.com/cli/latest/index.html
##############################

# list S3 buckets
echo "Print list of S3 buckets"
aws s3 ls > resourceTracker.txt

# list EC2 instances
echo "Print list of EC2 instances"

aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resourceTracker.txt

# list lambda
echo "Print list of Lambda Functions"
aws lambda list-functions >> resourceTracker.txt

# list IAM users
echo "Print list of IAM users"
aws iam list-users >> resourceTracker.txt


