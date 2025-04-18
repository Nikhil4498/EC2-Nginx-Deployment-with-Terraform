provider "aws" {
  region = "us-east-1"  # Or change to your preferred region
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-084568db4383264d4" # Ubuntu 20.04 LTS (us-east-1)
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.nginx_sg.id] 

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              echo "Welcome to the Terraform-managed Nginx Server on Ubuntu" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Terraform-Nginx-Server"
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}


output "instance_public_ip" {
  value = aws_instance.nginx_server.public_ip
}