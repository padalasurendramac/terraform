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
