#!bin/bash
cd ~
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
./get-docker.sh
apt update
apt install -y awscli docker-compose
aws ecr get-login-password --region ${region}  | docker login --username AWS --password-stdin ${ecr_address}
echo "done" > init.log
