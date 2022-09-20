#!/bin/bash

REGION=$(wget -qO- http://instance-data/latest/meta-data/placement/region)
GIT_TOKEN=$(aws ssm get-parameter --name /github/repo/token --with-decryption --query Parameter.Value --output text --region $REGION)
[ ! -d /home/ec2-user/data ] && git clone https://${GIT_TOKEN}@github.com/vijay2181/packer-gitclone-test.git /home/ec2-user/data || ( cd /home/ec2-user/data ; git pull )

#Supplied Tags along with AMI id, security group id, iam role etc while creating ec2 instance
#we can read those tags in user data when provisioning dynamic ec2 instance
INSTANCE_ID=$(wget -qO- http://instance-data/latest/meta-data/instance-id)
aws ec2 describe-tags --region $REGION --filter "Name=resource-id,Values=$INSTANCE_ID" --output=text | sed -r 's/TAGS\t(.*)\t.*\t.*\t(.*)/\1="\2"/' > /home/ec2-user/ec2-tags

#executing master script
bash /home/ec2-user/data/master.sh
