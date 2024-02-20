#!/bin/bash


until [[ "$rez" = "0%" ]]
do
rez=$(ping -c 1 8.8.8.8 | grep % | cut -d ' ' -f6)
echo "No internet"
done
echo "Internet is here"
sudo sh -c "echo 'port ${ssh_port}' >> /etc/ssh/sshd_config"
sudo systemctl restart sshd.service

allocateID=$(aws ec2 describe-addresses --region eu-west-2  --filters "Name=tag:role,Values=bastion" | jq -r '.Addresses[0].AllocationId')
instanceID=$(ec2-metadata -i | awk '{print $2}')
echo "start allocate public ip"

aws ec2  associate-address  --instance-id $instanceID --allocation-id  $allocateID

echo "finish allocate public ip"