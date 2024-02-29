####### provider #######
provider "aws" {
  region = "us-east-1"
}

#######  resource ####### 
resource "aws_instance" "nginx-server" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  key_name = aws_key_pair.nginx-server-ssh.key_name
  
  vpc_security_group_ids = [
	aws_security_group.nginx-server-sg.id
  ]

  tags = {
    Name        = "nginx-server"
    Environment = "test"
    Owner       = "ariel.molina@caosbinario.com"
    Team        = "DevOps"
    Project     = "webinar"
  }
}

####### ssh ####### 
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"

resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "nginx-server-ssh"
  public_key = file("nginx-server.key.pub")

  tags = {
    Name        = "nginx-server-ssh"
    Environment = "test"
    Owner       = "ariel.molina@caosbinario.com"
    Team        = "DevOps"
    Project     = "webinar"
  }
}

####### SG ####### 
resource "aws_security_group" "nginx-server-sg" {
  name        = "nginx-server-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nginx-server-sg"
    Environment = "test"
    Owner       = "ariel.molina@caosbinario.com"
    Team        = "DevOps"
    Project     = "webinar"
  }
}

#######  output ####### 
output "server_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.nginx-server.public_dns
}