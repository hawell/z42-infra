resource "aws_elasticache_subnet_group" "redis_subnet_group" {
   name       = "redis-subnet-group"
   subnet_ids = ["${element(module.vpc.private_subnets,2)}"]
}

resource "aws_elasticache_parameter_group" "default" {
   name   = "default"
   family = "redis7"
   
   parameter {
      name  = "notify-keyspace-events"
      value = "AKE"
   }
}

resource "aws_elasticache_cluster" "z42_redis" {
   cluster_id           = "redis-cluster"
   engine               = "redis"
   engine_version       = "7.0"
   node_type            = "cache.t3.micro"
   num_cache_nodes      = 1
   parameter_group_name = aws_elasticache_parameter_group.default.name
   port                 = 6379
   subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
   security_group_ids   = ["${aws_security_group.redis_sg.id}"]
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
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "redis_address" {
   value = aws_elasticache_cluster.z42_redis.cache_nodes[*].address
}
