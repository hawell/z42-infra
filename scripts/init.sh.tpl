#!bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1
cd ~
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
./get-docker.sh
apt update
apt install -y awscli
aws ecr get-login-password --region ${region}  | docker login --username AWS --password-stdin ${ecr_address}
docker run -d -p 80:80 ${ecr_address}/z42-nginx:latest
echo "done" > init.log
