provider "aws" {
  region = "us-west-2"   # us-west-2 oregan region and below image from same region available ami id
}


variable "vpc_cidr" {
  description = "vpc cidr"
  default = "10.0.0.0/16"
}
variable "private_subnet_cidr" {
  description = "private subnet cider"
   default = "10.0.2.0/24"
}

variable "public_subnet_cidr" {
  description = "public subnet cider"
   default = "10.0.1.0/24"
}
variable "ami" {
  description = "amazon ami"
   default = "ami-0b28dfc7adc325ef4"
}
variable "key_path" {
  description = "pem key path"
   default = "C:\\Users\\LENOVO\\.ssh\\id_rsa.pub"
}

# creation vpc 
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
  }
}
#define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  tags = {
    Name = "public subnet"
  }
}
#define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  tags = {
    Name = "private subnet"
  }
}
#creation internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "vpc IGW"
  }
}

# define the route table
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "public subnet rt"
  }
}
# Assign the route table to the public subnet 
resource "aws_route_table_association" "public_rt" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

# security group web

resource "aws_security_group" "sgweb" {
  name = "vpc_test_web"
  description = "allow incoming HTTP connection & SSH access"
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
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "web_server"
  }

}

# security group db

resource "aws_security_group" "sgdb" {
  name = "vpc_test_db"
  description = "allow incoming HTTP connection & SSH access"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "DB sg"
  }

}

# ssh key pair for our instancess
resource "aws_key_pair" "default" {
  key_name = "vpctest"
  public_key = "${file("${var.key_path}")}"
}

# ec2 instance web

resource "aws_instance" "wb" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = <<-EOF
              #!/bin/sh
              yum install -y httpd
              service start httpd
              chkconfig httpd on 
              echo "<html><h1>Hello from surendra </h1></html> > /var/www/html/index.html
              EOF
  tags = {
    Name = "webserver"
  }
}


# database instance
resource "aws_instance" "db" {
  instance_type = "t2.micro"
  ami = "${var.ami}"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgdb.id}"]
  source_dest_check = false
  tags = {
    Name = "database"
  }
}


