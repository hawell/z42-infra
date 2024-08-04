terraform {
  required_providers {
    mysql = {
      source = "winebarrel/mysql"
      version = "1.10.6"
    }
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
   name       = "rds_subnet_group"
   subnet_ids = ["${element(module.vpc.private_subnets,0)}","${element(module.vpc.private_subnets,1)}"]
}

resource "aws_db_instance" "z42database" {
   identifier = "z42database"
   allocated_storage = 20
   storage_type = "gp2"
   instance_class = "db.t3.micro"
   engine = "mysql"
   engine_version = "8.0.36"
   db_name = "z42"
   username = var.db_username
   password = var.db_password
   publicly_accessible    = false
   skip_final_snapshot    = true
   vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
   db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    description     = "allow mysql connections from ec2"
    from_port       = "3306"
    to_port         = "3306"
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

output "database_endpoint" {
   value = aws_db_instance.z42database.address
}

output "database_port" {
   value = aws_db_instance.z42database.port
}

