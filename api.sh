#!/bin/bash 

sleep 30

sudo yum update -y

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
sudo yum install -y nodejs
node -e "console.log('Running Node.js ' + process.version)"

sudo yum install unzip -y
cd ~/ && unzip exchange-22a-ubuntu.zip
cd ~/exchange-22a-ubuntu 
cd api && npm install

sleep 30

cd ../.. && rm -rf exchange-22a-ubuntu.zip