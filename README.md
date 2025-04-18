# EC2-Nginx-Deployment-with-Terraform
# Terraform Nginx EC2 Deployment on AWS

This project demonstrates how to deploy an Nginx web server on an EC2 instance using Terraform on AWS. The infrastructure includes:

- EC2 instance running Ubuntu
- Security Group allowing HTTP and SSH
- User data script to install and start Nginx
- Public IP output to access the deployed web server

## 📁 Project Structure

terraform-nginx-ubuntu/ 
├── main.tf       # This is the main Terraform configuration file. It defines the resources needed for deploying the EC2 instance and security group.
├── variables.tf  # This file contains the variables used in the `main.tf` file. For example, the AMI ID, instance type, and key name can be defined here.
├── outputs.tf    # Defines the outputs of the Terraform deployment, such as the public IP of the created EC2 instance.
├── README.md     #The file you are currently reading, which explains the steps involved in deploying the EC2 instance with Terraform.



## Terraform Configuration Details


(a)   main.tf

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
                        
                        
                        
(b)    variables.tf

            variable "instance_type" {
            description = "EC2 instance type"
            default     = "t2.micro"
            }

          variable "key_name" {
          description = "SSH key name to access the instance"
          default     = "your actual EC2 key pair name"  # Replace with your actual EC2 key pair name
          }

(c) outputs.tf

          output "instance_public_ip" {
            value = aws_instance.nginx_server.public_ip
          }

          
## Steps to Deploy
(i) Initialize Terraform:

      terraform init
      
(ii) Plan the Deployment:

      terraform plan
      
(iii) Apply the Configuration:

      terraform apply
      
    ## Type 'yes' when prompted

(iv) Get the Public IP:

        terraform output
        
        Access Nginx in Browser
        
        Navigate to http://<instance_public_ip>
        Example: http://44.212.33.180


(v) To destroy all resources:

    terraform destroy
    
## .gitignore (Important for Security):

      gitignore
      Copy
      Edit
      *.tfstate
      *.tfstate.*
      .terraform/
      .terraform.lock.hcl
      crash.log
      *.backup



