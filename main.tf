provider "aws" {
   access_key = var.aws_access_key
   secret_key = var.aws_secret_key
   region = var.aws_region
}

resource "aws_instance" "webserver" {
   instance_type          = "${var.instance_type}"
   ami                    = "${lookup(var.aws_amis, var.aws_region)}"
   iam_instance_profile   = aws_iam_instance_profile.profile.name
   key_name               = aws_key_pair.z42keypair.key_name
   vpc_security_group_ids = ["${aws_security_group.allow_ports.id}"]
   subnet_id              = "${element(module.vpc.public_subnets,0)}"
   user_data              = "${data.template_file.init.rendered}"

   tags = {
      Name = "Webserver"
   }

   connection {
      type           = "ssh"
      user           = "ubuntu"
      private_key    = tls_private_key.z42key.private_key_openssh
      host           = "${self.public_ip}"
   }

   provisioner "file" {
      destination = "/tmp/docker-compose.yml"
      content = templatefile("./scripts/docker-compose.yml.tpl", {
         ecr_address = "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
      })
   }

   provisioner "remote-exec" {
      inline = [
         "sudo cloud-init status --wait",
         "sudo mv /tmp/docker-compose.yml /var/docker-compose.yml",
         "sudo docker-compose -f /var/docker-compose.yml up -d"
         ]
   }
}

resource "aws_eip" "webserver-eip" {
   instance = aws_instance.webserver.id
   vpc = true
}
