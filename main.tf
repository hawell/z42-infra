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
}

resource "aws_eip" "webserver-eip" {
  instance = aws_instance.webserver.id
  vpc = true
}


