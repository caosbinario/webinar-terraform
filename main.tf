####### provider #######
provider "aws" {
  region = "us-east-1"
}

#######  resource ####### 
resource "aws_instance" "nginx-server" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t3.micro"
}