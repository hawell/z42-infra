resource "aws_elasticache_subnet_group" "redis_subnet_group" {
   name       = "redis-subnet-group"
   subnet_ids = ["${element(module.vpc.private_subnets,2)}"]
}


resource "aws_elasticache_cluster" "z42_redis" {
   cluster_id           = "redis-cluster"
   engine               = "redis"
   engine_version       = "7.0"
   node_type            = "cache.t3.micro"
   num_cache_nodes      = 1
   parameter_group_name = "default.redis7"
   port                 = 6379
   subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
   security_group_ids   = ["${aws_security_group.redis_sg.id}"]
}
