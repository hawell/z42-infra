output "vpc_id" {
   value = ["${module.vpc.vpc_id}"]
}

output "vpc_public_subnets" {
   value = ["${module.vpc.public_subnets}"]
}

output "webserver_ids" {
   value = ["${aws_instance.webserver.*.id}"]
}

output "ip_addresses" {
   value = ["${aws_instance.webserver.*.id}"]
}

output "private_pem" {
   sensitive = true
   value = tls_private_key.z42key.private_key_pem
}

output "ecr_address" {
   value = "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "database_endpoint" {
   value = aws_db_instance.z42_rds.address
}

output "database_port" {
   value = aws_db_instance.z42_rds.port
}

output "redis_address" {
   value = aws_elasticache_cluster.z42_redis.cache_nodes[*].address
}