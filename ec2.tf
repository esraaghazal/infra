resource "aws_security_group" "ec2" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

### ssh rules ###

  ingress 
  { from_port = 22
    to_port = 22   
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] }

## http rules ##

  ingress { 
    from_port = 80   
    to_port = 80   
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] }
  
### outbound rules ###
#allow all traffic 
  egress  { 
    from_port = 0    
    to_port = 0    
    protocol = "-1"  
    cidr_blocks = ["0.0.0.0/0"] }

  tags = { Name = "ec2-sg" }
}


### rds sg ####

resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = aws_vpc.main.id
  
### mysql rule ####
# will comunicate with only the ec2s that have the ec2-sg

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  tags = { Name = "rds-sg" }
}


resource "aws_instance" "frontend" {
  ami                    = var.ami
  instance_type          = "t3.micro"
  # to launch in the public subnet 
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name
  # to give the ec2 a public ip 
  associate_public_ip_address = true

  root_block_device { 
    volume_size = 8 
    volume_type = "gp3" }
# a userdata script that install a docker and docker compose when we lanch the ec2 instance
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io docker-compose-plugin
    systemctl enable docker
  EOF

  tags = { Name = "frontend-uptimekuma" }
}

resource "aws_instance" "backend" {
  ami                    = var.ami
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name
  associate_public_ip_address = true

  root_block_device { volume_size = 8; volume_type = "gp3" }
# a userdata script that install the requierments to run a php project
  user_data = <<-EOF
    #!/bin/bash
    apt update -y && apt upgrade -y
    apt install -y php8.2 php8.2-mysql apache2 git composer unzip
    a2enmod rewrite
    systemctl restart apache2
  EOF

  tags = { Name = "backend-laravel" }
}