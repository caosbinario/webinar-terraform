####### tfstate #######

terraform {
  backend "s3" {
    bucket         = "webinar-terraform-caosbinario-123asd123ad123asd"
    key            = "webinar-terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}

####### modulos #######
module "nginx_server_dev" {
    source = "./nginx_server_module"

    ami_id           = "ami-0440d3b780d96b29d"
    instance_type    = "t3.medium"
    server_name      = "nginx-server-dev"
    environment      = "dev"
}

module "nginx_server_qa" {
    source = "./nginx_server_module"

    ami_id           = "ami-0440d3b780d96b29d"
    instance_type    = "t3.small"
    server_name      = "nginx-server-qa"
    environment      = "qa"
}

#######  output ####### 
output "nginx_dev_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_dev.server_public_dns
}

output "nginx_qa_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_qa.server_public_dns
}

##### Import

# aws_instance.server-web:
resource "aws_instance" "server-web" {
    ami                                  = "ami-0440d3b780d96b29d"
    instance_type                        = "t2.medium"
    tags = {
        Name        = "server-web"
        Environment = "test"
        Owner       = "ariel.molina@caosbinario.com"
        Team        = "DevOps"
        Project     = "webinar"
    }
    vpc_security_group_ids               = [
        "sg-0d5b0d5e416f094c1",
    ]
}
