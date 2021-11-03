# Setup terrform on windows 


### download terrformform zip or install exe file

### Method 1 for passing aws keys auth

    aws confgure  # use this command to export user keys before enter command create an user with full access permssion on aws
    	C:\Users\LENOVO\test>aws configure
		AWS Access Key ID [***********]:
		AWS Secret Access Key [************]:
		Default region name [us-west-2]:
		Default output format [text]:

### Method 2 directly mentioned under provider like below 
    provider "aws" {
    access_key = "********************"
    secret_key = "****************************************"
    region = "us-west-2"   # us-west-2 oregan region and below image from same region available ami id
    }

###  varibles types are 3 types on terraform

	a) default
	b) list
	c) map
	
### syntax single variable
		variable "server_port" {
		  description = "The port the server will use for HTTP requests"
		  default = 8080
		}
	
### syntax ( multi variables ) for list

		variable "list_example" {
		  description = "An example of a list in Terraform"
		  type = "list"
		  default = [1, 2, 3]
		}
		And here’s a map:
### syntax for variables with vaules map 
		variable "map_example" {
		  description = "An example of a map in Terraform"
		  type = "map"
		  default = {
		    key1 = "value1"
		    key2 = "value2"
		    key3 = "value3"
		 }
		}

### output to get ips public_ip and private_ip ( code should be last )
  
	output "public_ip" {
  	  value = "${aws_instance.example.public_ip}"
        }
-----------------output----
     	Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

	Outputs:

	public_ip = "5*.21*.24*.**"

###  then

### run 

     terrform -version




### step:-1
    terrform init



### step:-2
    terrform plan 



### step:3

    terraform apply

### after enter above command pop to enter vaule just type "yes"


### delete the create instance use below command

    terraform destroy
