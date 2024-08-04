provider "aws" {
   access_key = var.aws_access_key
   secret_key = var.aws_secret_key
   region = var.aws_region
}

resource "aws_instance" "webserver" {
   instance_type          = "${var.instance_type}"
   ami                    = "${lookup(var.aws_amis, var.aws_region)}"
   iam_instance_profile   = aws_iam_instance_profile.profile.name
   key_name               = aws_key_pair.chordsoft_keypair.key_name
   vpc_security_group_ids = ["${aws_security_group.ec2_sg.id}"]
   subnet_id              = "${element(module.vpc.public_subnets,0)}"
   user_data              = "${data.template_file.init.rendered}"

   tags = {
      Name = "Webserver"
   }

   connection {
      type           = "ssh"
      user           = "ubuntu"
      private_key    = tls_private_key.chordsoft_key.private_key_openssh
      host           = "${self.public_ip}"
   }

}

resource "aws_eip" "webserver-eip" {
   instance = aws_instance.webserver.id
   domain = "vpc"
}

resource "aws_security_group" "ec2_sg" {
   name        = "ec2_sg"
   description = "Allow inbound SSH traffic and http from any IP"
   vpc_id      = "${module.vpc.vpc_id}"

   #ssh access
   ingress {
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   # HTTP access
   ingress {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
       from_port = 443
       to_port   = 443
       protocol  = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
       from_port = 53
       to_port   = 53
       protocol  = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
       from_port = 53
       to_port   = 53
       protocol  = "udp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
       Name = "Allow SSH and HTTP and DNS"
   }
}

output "webserver_ids" {
   value = ["${aws_instance.webserver.*.id}"]
}

output "ip_addresses" {
   value = ["${aws_instance.webserver.*.id}"]
}

output "public_dns" {
   value = ["${aws_instance.webserver.*.public_dns}"]
}

output "private_ip" {
   value = ["${aws_instance.webserver.*.private_ip}"]
}
