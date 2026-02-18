resource "aws_db_subnet_group" "main" {
  name       = "three-tier-db-subnet-group"
  subnet_ids = var.private_subnets
}


resource "aws_db_instance" "postgres" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
}
