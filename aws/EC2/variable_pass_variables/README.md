# Keypoints varible passing through cmd

###  variables mentioning
    variable "server_port" {
      description = "The port the server will use for HTTP requests"
    }

### mention methon on resource 
    "${var.server_port}"


### Run terraform commmand

    terraform plan -var server_port="8080"
    terraform plan -var server_port="8080"
    
    
