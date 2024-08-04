data "template_file" "api-config-template" {
    template = "${file("./runtime/z42/configs/api-config.json.tpl")}"
    vars = {
        database_user = "${var.db_username}"
        database_password = "${var.db_password}"
        database_address = "${aws_db_instance.z42database.address}"
        database_port = "${aws_db_instance.z42database.port}"
        recaptcha_secret_key = "${var.recaptcha_key}"
        email_user = "${aws_iam_access_key.access_key.id}"
        email_password = "${aws_iam_access_key.access_key.ses_smtp_password_v4}"
    }
}

output "api-config" {
    sensitive = true
    value = "${data.template_file.api-config-template.rendered}"
}

data "template_file" "resolver-config-template" {
    template = "${file("./runtime/z42/configs/resolver-config.json.tpl")}"
    vars = {
        redis_address = "${aws_elasticache_cluster.z42_redis.cache_nodes[0].address}"
        redis_port = "${aws_elasticache_cluster.z42_redis.cache_nodes[0].port}"
    }
}

output "resolver-config" {
    sensitive = true
    value = "${data.template_file.resolver-config-template.rendered}"
}

data "template_file" "updater-config-template" {
    template = "${file("./runtime/z42/configs/updater-config.json.tpl")}"
    vars = {
        database_user = "${var.db_username}"
        database_password = "${var.db_password}"
        database_address = "${aws_db_instance.z42database.address}"
        database_port = "${aws_db_instance.z42database.port}"
        redis_address = "${aws_elasticache_cluster.z42_redis.cache_nodes[0].address}"
        redis_port = "${aws_elasticache_cluster.z42_redis.cache_nodes[0].port}"
    }
}

output "updater-config" {
    sensitive = true
    value = "${data.template_file.updater-config-template.rendered}"
}

data "template_file" "auth-config-template" {
    template = "${file("./runtime/auth/configs/auth-config.json.tpl")}"
    vars = {
        database_user = "${var.db_username}"
        database_password = "${var.db_password}"
        database_address = "${aws_db_instance.z42database.address}"
        database_port = "${aws_db_instance.z42database.port}"
        recaptcha_secret_key = "${var.recaptcha_key}"
        email_user = "${aws_iam_access_key.access_key.id}"
        email_password = "${aws_iam_access_key.access_key.ses_smtp_password_v4}"
    }
}

output "auth-config" {
    sensitive = true
    value = "${data.template_file.auth-config-template.rendered}"
}
