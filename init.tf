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