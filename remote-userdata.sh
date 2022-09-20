#!/bin/bash

GIT_TOKEN=$(aws ssm get-parameter --name /github/repo/token --with-decryption --query Parameter.Value --output text --region us-west-2)
[ ! -d /home/ec2-user/data ] && git clone https://${GIT_TOKEN}@github.com/vijay2181/packer-gitclone-test.git /home/ec2-user/data || ( cd /home/ec2-user/data ; git pull )

bash /home/ec2-user/data/master.sh

#Supplied Tags along with AMI id, security group id, iam role etc while creating ec2 instance
#we can read tags in user data when provisioning dynamic ec2 instance
InstanceId=$(wget -qO- http://instance-data/latest/meta-data/instance-id)
Region=$(wget -qO- http://instance-data/latest/meta-data/placement/region)
aws ec2 describe-tags --region $Region --filter "Name=resource-id,Values=$InstanceId" --output=text | sed -r 's/TAGS\t(.*)\t.*\t.*\t(.*)/\1="\2"/' > /home/ec2-user/ec2-tags
