#!/bin/bash

GIT_TOKEN=$(aws ssm get-parameter --name /github/repo/token --with-decryption --query Parameter.Value --output text --region us-west-2)
[ ! -d /home/ec2-user/data ] && git clone https://${GIT_TOKEN}@github.com/vijay2181/packer-gitclone-test.git /home/ec2-user/data || ( cd /home/ec2-user/data ; git pull )

bash /home/ec2-user/data/master.sh
