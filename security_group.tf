resource "aws_security_group" "allow_ports" {
   name        = "allow_ssh_http"
   description = "Allow inbound SSH traffic and http from any IP"
   vpc_id      = "${module.vpc.vpc_id}"

   #ssh access
   ingress {
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       # Restrict ingress to necessary IPs/ports.
       cidr_blocks = ["0.0.0.0/0"]
   }

   # HTTP access
   ingress {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       # Restrict ingress to necessary IPs/ports.
       cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
       from_port = 443
       to_port   = 443
       protocol  = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
       Name = "Allow SSH and HTTP"
   }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    description     = "allow mysql connections from ec2"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ports.id]
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "redis_sg"
  description = "redis security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    description     = "allow redis connections from ec2"
    from_port       = "6379"
    to_port         = "6379"
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ports.id]
  }
}
