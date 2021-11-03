provider "aws" {
  region = "us-west-2"   # us-west-2 oregan region and below image from same region available ami id
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
}

resource "aws_security_group" "instance" {
  name = "terraform-example"
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami = "ami-0b28dfc7adc325ef4"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

}


