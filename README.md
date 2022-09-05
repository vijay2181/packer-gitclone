# packer

procedure to checkout code from github while dynamic provisioning of ec2-instance

- we need to provision ec2 instance in such a way that while the instance is up and running, it should checkout a particular usecase github repository

- so for that, we need an ami built with packer with all required softwares encapsulated in it...and which will have a shell script placed in /var/lib/cloud/scripts/per-instance/ of remote instance so that whenever a new instance is launched from this ami, then that shell script will act as userdata for each new instance

- this shell script will have logic to get git token from aws ssm parameter store and checkout the repository


install packer
---------------
cd /opt

sudo yum update -y

sudo wget https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip

sudo unzip packer_1.4.2_linux_amd64.zip

sudo mv packer /usr/local/bin/

packer --version
  
  
  
configure access and secrect keys
----------------------------------
cd /home/ec2-user

mkdir .aws

vi config

[profile test]

aws_access_key_id=

aws_secret_access_key=

region=


- by using this profile, packer will authenticate to aws and create ami for you

- goto parameter store, create and place the github token "/github/repo/token"   -- secure string

- create a role with the below policy and attach to ec2-instance to get required parameters(git token) from parameter store

- the provisioned instance where this shell script will act as userdata need to have permission to get paramter from parameter store and decrypt it, so we can have a role for ec2-instance like below example policy

policy for parameter store:-
---------------------------


{

    "Version": "2012-10-17",
    
    "Statement": [
    
        {
        
            "Action": [
            
                "ssm:GetParameter"
                
            ],
            
            "Resource": [
            
                "arn:aws:ssm:us-west-2:<aws-account-id>:parameter/github/repo/*"
                
            ],
            
            "Effect": "Allow"
            
        }
        
    ]
    
}



procedure
---------
cd /home/ec2-user

git clone https://github.com/vijay2181/packer-gitclone.git

cd packer-gitclone

packer validate instance.json

packer build instance.json
  
