resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "task-vpc" }
}

######### gateway ############

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "task-igw" }
}

####### public subnet ###########

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  #  when ec2 launch it will take public ip 
  map_public_ip_on_launch = true
  tags                    = { Name = "public-a" }
}

########## private subnet ###########

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
  tags              = { Name = "private-a" }
}

############# db subnet ##############
# when we create rds use subnet from this subnet ids dont create it in another subnet 
resource "aws_db_subnet_group" "private" {
  name       = "private-db-subnet"
  subnet_ids = [aws_subnet.private_a.id]
  tags       = { Name = "private-db-subnet-group" }
}

## route teble

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-rt" }
}

# any trrafic come to 0.0.0.0/0 forwared it to the gaeway

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# connect the public subnet with route table 

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

