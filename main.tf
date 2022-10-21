#creating a VPC
resource "aws_vpc" "wordpressapp" {
  cidr_block           = var.wordpressapp-vpc-cidr
  enable_dns_hostnames = true

  tags = {
    "Name" = "wordpressapp"
  }
}

#public ALB NAT server subnet AZ 2a
resource "aws_subnet" "PublicALBNAT1Sub" {
  vpc_id                  = aws_vpc.wordpressapp.id
  cidr_block              = var.publicALBNAT1subcidr
  availability_zone       = var.AZ2a
  map_public_ip_on_launch = true

  tags = {
    "Name" = "PublicALBNAT1Sub"
  }
}

#private Web server subnet AZ 2a
resource "aws_subnet" "PrivateWeb1Sub" {
  vpc_id                  = aws_vpc.wordpressapp.id
  cidr_block              = var.privateweb1subcidr
  availability_zone       = var.AZ2a
  map_public_ip_on_launch = false

  tags = {
    "Name" = "PrivateWeb1Sub"
  }
}

#private DB server subnet AZ 2a
resource "aws_subnet" "PrivateDB1Sub" {
  vpc_id                  = aws_vpc.wordpressapp.id
  cidr_block              = var.privatedb1subcidr
  availability_zone       = var.AZ2a
  map_public_ip_on_launch = false

  tags = {
    "Name" = "PrivateDB1Sub"
  }
}

#public ALB NAT server subnet AZ 2b
resource "aws_subnet" "PublicALBNAT2Sub" {
  vpc_id                  = aws_vpc.wordpressapp.id
  cidr_block              = var.publicALBNAT2subcidr
  availability_zone       = var.AZ2b
  map_public_ip_on_launch = true

  tags = {
    "Name" = "PublicALBNAT2Sub"
  }
}

#private Web server subnet AZ 2b
resource "aws_subnet" "PrivateWeb2Sub" {
  vpc_id                  = aws_vpc.wordpressapp.id
  cidr_block              = var.privateweb2subcidr
  availability_zone       = var.AZ2b
  map_public_ip_on_launch = false

  tags = {
    "Name" = "PrivateWeb2Sub"
  }
}

#private DB server subnet AZ 2b
resource "aws_subnet" "PrivateDB2Sub" {
  vpc_id                  = aws_vpc.wordpressapp.id
  cidr_block              = var.privatedb2subcidr
  availability_zone       = var.AZ2b
  map_public_ip_on_launch = false

  tags = {
    "Name" = "PrivateDB2Sub"
  }
}

#creating and attaching IGW
resource "aws_internet_gateway" "wordpressIGW" {
  vpc_id = aws_vpc.wordpressapp.id

  tags = {
    "Name" = "wordpressIGW"
  }
}

#creating EIP for NAT 1
resource "aws_eip" "NAT1" {
  vpc = true

  tags = {
    "Name" = "NAT1"
  }
}

#creating EIP for NAT 2
resource "aws_eip" "NAT2" {
  vpc = true

  tags = {
    "Name" = "NAT2"
  }
}

#creating NAT Gateway for AZ2a
resource "aws_nat_gateway" "wordpressNAT1" {
  allocation_id = aws_eip.NAT1.id
  subnet_id     = aws_subnet.PublicALBNAT1Sub.id
  tags = {
    "Name" = "wordpressNAT1"
  }
}

#creating NAT Gateway for AZ2b
resource "aws_nat_gateway" "wordpressNAT2" {
  allocation_id = aws_eip.NAT2.id
  subnet_id     = aws_subnet.PublicALBNAT2Sub.id
  tags = {
    "Name" = "wordpressNAT2"
  }
}

#creating a public route table
resource "aws_route_table" "wordpressPublicRT" {
  vpc_id = aws_vpc.wordpressapp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpressIGW.id
  }

  tags = {
    "Name" = "wordpressPublicRT"
  }
}

#creating a private route table for AZ 2a
resource "aws_route_table" "wordpressPrivateRT1" {
  vpc_id = aws_vpc.wordpressapp.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wordpressNAT1.id
  }

  tags = {
    "Name" = "wordpressPublicRT1"
  }
}

#creating a private route table for AZ 2b
resource "aws_route_table" "wordpressPrivateRT2" {
  vpc_id = aws_vpc.wordpressapp.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wordpressNAT2.id
  }

  tags = {
    "Name" = "wordpressPublicRT2"
  }
}

#creating a route table association for AZ2a 1
resource "aws_route_table_association" "wordpressPub1RTA" {
  subnet_id      = aws_subnet.PublicALBNAT1Sub.id
  route_table_id = aws_route_table.wordpressPublicRT.id
}

#creating a route table association for AZ2b 2
resource "aws_route_table_association" "wordpressPub2RTA" {
  subnet_id      = aws_subnet.PublicALBNAT2Sub.id
  route_table_id = aws_route_table.wordpressPublicRT.id
}

#creating a route table association for web of AZ2a 1 
resource "aws_route_table_association" "wordpressPriweb1RTA2a" {
  subnet_id      = aws_subnet.PrivateWeb1Sub.id
  route_table_id = aws_route_table.wordpressPrivateRT1.id
}

#creating a route table association for db of AZ2a 2
resource "aws_route_table_association" "wordpressPridb2RTA2a" {
  subnet_id      = aws_subnet.PrivateDB1Sub.id
  route_table_id = aws_route_table.wordpressPrivateRT1.id
}

#creating a route table association for web of AZ2b 1 
resource "aws_route_table_association" "wordpressPriweb1RTA2b" {
  subnet_id      = aws_subnet.PrivateWeb2Sub.id
  route_table_id = aws_route_table.wordpressPrivateRT2.id
}

#creating a route table association for db of AZ2b 2
resource "aws_route_table_association" "wordpressPridb2RTA2b" {
  subnet_id      = aws_subnet.PrivateDB2Sub.id
  route_table_id = aws_route_table.wordpressPrivateRT2.id
}

#create security group for the ALB  
resource "aws_security_group" "albSG" {
  name = "wordpress-alb-sg"
  description = "This  is the SG for the ALB"
  vpc_id = aws_vpc.wordpressapp.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating the ALB
resource  "aws_alb" "wordpressAlb" {
  name = "wordpressAlb"
  security_groups = ["${aws_security_group.albSG.id}"]
  subnets = ["${aws_subnet.PublicALBNAT1Sub.id}", "${aws_subnet.PublicALBNAT2Sub.id}" ]
  tags = {
    "Name" = "wordpressAlb"
  }
}

#create the ALB target 
resource "aws_alb_target_group" "wordpressALBtargetgroup" {
  name = "wordpressALBtargetgroup"
  port =  80
  protocol = "HTTP"
  vpc_id = aws_vpc.wordpressapp.id
    stickiness {
    type = "lb_cookie"
    }
}

# create ALB Listerner HTTPS
resource "aws_alb_listener" "wordpressALBListerner" {
  load_balancer_arn = aws_alb.wordpressAlb.arn
  port = 80
  protocol = "HTTP"
    default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.wordpressALBtargetgroup.arn
    }
}

#Create EC2 instance to host Web app
resource "aws_instance" "Wordpressinstance" {
  count = 5
  ami = var.ami_instance
  instance_type = var.instance_type
  key_name = "keypair"
  vpc_security_group_ids = ["${aws_security_group.WPsg.id}"]
    tags = {
      "Name" = "Wordpress-linux"
    }
  }


#Create the security group
resource "aws_security_group" "WPsg" {
  name = "WPsg"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.wordpressapp.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a keypair
resource  "aws_key_pair" "WPkey-pair" {
  key_name = "keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDsqGjPTt0yWE6Cb924OzRoO6YoNbAA3sPBgyaJa7clUZOo6N2KXZ1WGazSVYTomNlSrgaPS66GG+lIr+MxFJpIDHrOJPblfH+qz8DQTSjdZQiUByuWscxtMiLijv7ZFg36nqEPJwvhPOBn6rHD/4mwsgmgvHXvuKZnLOoJdDPKpUV3dAVPfQX2uKS/kMqYlT/CPaIy7d2kj1we5DUx1zNNs9Ssc9VItGPO29B5R7jplhYISfJjXP6xlTcRlgnYUo+hPsTv7++XS1zrkwxnfr94paBW+ZQa5AGL15khvx4RNyGRLUsphqld18tgPgWMFj79pCU0XI+Js3U6/S2Vx5G1ZPiAms5qxf+6s5H/VCB351yZXvloIMFibbwJanU1CpC2EvZkNEqGbUsPCJjbWWOH4VsY7U0XsEzethinamkMwUXqcaKWbCLJqUQ2yvqiBQLaNGqjHPOa05I7dCiSvGlPmbbilZEcSJ+NvDB2dBPGOuh0HuQh1n/YyIhe98nqvy8= user@DESKTOP-04SCITU"
}

#create your RDS instance
resource "aws_db_instance" "wordpressDBinstance" {
  allocated_storage = var.DB_storage
  db_name = "wordpressDBinstance"
  engine = var.engine_type
  engine_version = "5.7"
  instance_class = var.DB_instance_class
  username = var.DBusername
  password = var.DBpassword
  parameter_group_name = "default.mysql5.7"
}

resource "aws_security_group" "WPDBsg" {
  name = "rds_sg"
  description = "Allow traffic from webapp"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.WPsg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a launch template for auto scaling group
resource "aws_launch_template" "WPlaunchtemplate" {
  name = "WPlaunchtemplate"
  image_id = var.ami_instance
  instance_type = var.instance_type
}

resource "aws_autoscaling_group"  "WPag" {
  availability_zones = ["${var.AZ2a}", "${var.AZ2b}"]
  desired_capacity = 10
  max_size = 10
  min_size = 10

  launch_template {
    id = aws_launch_template.WPlaunchtemplate.id
  
}
}








 