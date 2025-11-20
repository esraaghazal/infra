resource "aws_db_instance" "mysql" {
  identifier              = "app-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  db_name                 = "appdb"
  username                = "admin"
  # pass to acces the db
  password                = var.db_password
  # can not access the internet 
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.private.name
  # do notmake a snap when we delete the rds
  skip_final_snapshot     = true

  tags = { Name = "app-mysql" }
}