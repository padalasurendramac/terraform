### Key points  security group creating ( Resource aws_security_group )

### variable passing in side under resouce variable
      variable "server_port" {
        description = "web_server"
        default = 8080
      }
 
resource "aws_security_group" "instance" {
      name = "terraform-example"
      ingress {
        from_port = "${var.server_port}"   # passing variable server_port from varible resources
        to_port = "${var.server_port}"     # passing variable server_port from varible resources
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

### vpc resource passing under instance type resouce

    vpc_security_group_ids = ["${aws_security_group.instance.id}"]   # For get security group id 
