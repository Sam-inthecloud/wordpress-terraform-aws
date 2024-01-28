# Create a default VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}


# Create a subnet for EC2  AZ(1)
resource "aws_subnet" "subnet_a" {
    vpc_id                  = aws_vpc.default.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = "eu-west-2a"
    map_public_ip_on_launch = true //this makes it a public subnet
}


# Subnet for RDS AZ(2)
resource "aws_subnet" "subnet_b" {
    vpc_id                  = aws_vpc.default.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "eu-west-2b"
    map_public_ip_on_launch = false //this makes it a private subnet
}

#Another subnet for RDS AZ (3)
resource "aws_subnet" "subnet_c" {
    vpc_id = aws_vpc.default.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "eu-west-2c"
    map_public_ip_on_launch = false 
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
  }

#Create Route table
resource "aws_route_table" "wp_public" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

#Associate route table to public subnet
resource "aws_route_table_association" "wp_public_subnet_1" {
    subnet_id = aws_subnet.subnet_a.id
    route_table_id = aws_route_table.wp_public.id
}

# Create security group in default VPC
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow inbound traffic for WordPress"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = aws_vpc.default.id

  ingress = [
    {
      description = "MYSQL"
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      self = false
      security_groups = ["${aws_security_group.wordpress_sg.id}"]
    }
  ]

  egress = [
    {
      description = "for all outgoing traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = ["${aws_security_group.wordpress_sg.id}"]
      self = false
    }
  ]
}

  #Subnet group for RDS
  resource "aws_db_subnet_group" "RDS_subnet_grp" {
    subnet_ids = ["${aws_subnet.subnet_b.id}", "${aws_subnet.subnet_c.id}"]
  }

# Create an RDS instance in the default VPC and subnet
resource "aws_db_instance" "wordpress_db" {
    instance_class          = "db.t2.micro"
    allocated_storage       = 10
    storage_type            = "gp2"
    engine                  = "mysql"
    engine_version          = "5.7"
    db_name                 = "wordpressdb"
    username                = var.db_username
    password                = var.db_password
    parameter_group_name    = "default.mysql5.7"
    skip_final_snapshot     = true
    db_subnet_group_name    = aws_db_subnet_group.RDS_subnet_grp.id
    vpc_security_group_ids = ["${aws_security_group.RDS_allow_rule.id}"]
    multi_az                = true
}

# Create an EC2 instance
resource "aws_instance" "wordpress_instance" {
    ami                  = var.ami_id
    instance_type        = "t2.micro"
    key_name             = var.key_name
    vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
    subnet_id            = aws_subnet.subnet_a.id
}
