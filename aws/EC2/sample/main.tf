provider "aws" {
  region = "us-west-2"   # us-west-2 oregan region and below image from same region available ami id
}

resource "aws_instance" "example" {
  ami = "ami-0b28dfc7adc325ef4"
  instance_type = "t2.micro"
}
