provider "aws" {
  region = "us-west-2"  #test working
}

resource "aws_instance" "example" {
  ami = "ami-0b28dfc7adc325ef4"
  instance_type = "t2.micro"

  user_data = <<-EOF
	      #!/bin/bash
              echo "First hello word"
              EOF

  tags = {
    Name = "test2.com"
  }
}
