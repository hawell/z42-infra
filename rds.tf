resource "aws_db_subnet_group" "rds_subnet_group" {
   name       = "rds_subnet_group"
   subnet_ids = ["${element(module.vpc.private_subnets,0)}","${element(module.vpc.private_subnets,1)}"]
}

resource "aws_db_instance" "z42_rds" {
   identifier = "z42-rds"
   allocated_storage = 20
   storage_type = "gp2"
   instance_class = "db.t3.micro"
   engine = "mysql"
   engine_version = "8.0.27"
   db_name = "z42database"
   username = var.db_username
   password = var.db_password
   publicly_accessible    = false
   skip_final_snapshot    = true
   vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
   db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
}
