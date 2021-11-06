provider "aws" {
  region = "us-west-2"   # us-west-2 oregan region and below image from same region available ami id
}

resource "aws_vpc" "default" {

  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Main_vpc"
  }
}


#public-old
variable "pub-subnet1" {
  type = list
  default = ["10.0.1.0/24","old","us-west-2a"]
}

resource "aws_subnet" "pub1" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.pub-subnet1[0]
  availability_zone = var.pub-subnet1[2]
  tags = {
    Name = "public-${var.pub-subnet1[1]}"
  }
}


#public-new
variable "pub-subnet2" {
  type = list
  default = ["10.0.2.0/24","new","us-west-2b"]
}

resource "aws_subnet" "pub2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.pub-subnet2[0]
  availability_zone = var.pub-subnet2[2]
  tags = {
    Name = "public-${var.pub-subnet2[1]}"
  }
}


#private old
variable "pri-subnet1" {
  type = list
  default = ["10.0.3.0/24","old","us-west-2c"]
}

resource "aws_subnet" "pri1" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.pri-subnet1[0]
  availability_zone = var.pri-subnet1[2]
  tags = {
    Name = "private-${var.pri-subnet1[1]}"
  }
}
# private new
variable "pri-subnet2" {
  type = list
  default = ["10.0.4.0/24","new","us-west-2d"]
}

resource "aws_subnet" "pri2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.pri-subnet2[0]
  availability_zone = var.pri-subnet2[2]
  tags = {
    Name = "private-${var.pri-subnet2[1]}"
  }
}

#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "vpc IGW"
  }
}

# route table for public rt
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

# assign subnets to route tables public
resource "aws_route_table_association" "public_rt" {
  for_each = {
    pub1 = aws_subnet.pub1.id
    pub2 = aws_subnet.pub2.id
  }
  subnet_id = each.value
  route_table_id = "${aws_route_table.public_rt.id}"
}

#route table for private rt
resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "private subnet rt"
  }
}

## assign subnets to route tables private
resource "aws_route_table_association" "private_rt" {
  for_each = {
    pub1 = "${aws_subnet.pri1.id}"
    pub2 = "${aws_subnet.pri2.id}"
  }
  subnet_id = each.value
  route_table_id = "${aws_route_table.private_rt.id}"
}

# loop security group creation
resource "aws_security_group" "security-sg" {
  for_each = {
    pub1 = "${aws_subnet.pub1.id}"
    pub2 = "${aws_subnet.pub1.id}"
    pri1 = "${aws_subnet.pri1.id}"
    pri2 = "${aws_subnet.pri2.id}"
  }  
  name = "${each.key}"
  description = "security group"
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
    Name = "${each.key}-${each.value}"
  }
}


