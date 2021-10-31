provider "aws" {
  region = "us-west-2"   # us-west-2 oregan region and below image from same region available ami id
}

resource "aws_s3_bucket" "suri_test" {
    bucket = "surendra1232456"     # unique  name 
    acl    = "private" 
}
