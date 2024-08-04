data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

data "template_file" "init" {
  template = "${file("./scripts/init.sh.tpl")}"

  vars = {
    ecr_address = "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    region = "${var.aws_region}"
  }
}

data "template_file" "docker_compose" {
  template = "${file("./runtime/docker-compose.yml.tpl")}"

  vars = {
    ecr_address = "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    region = "${var.aws_region}"
    recaptcha_key = "${var.recaptcha_key}"
  }
}

output "docker_compose" {
  value = "${data.template_file.docker_compose.rendered}"
}
