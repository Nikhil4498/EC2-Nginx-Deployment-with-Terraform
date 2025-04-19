# EC2-Nginx-Deployment-with-Terraform
# Terraform Nginx EC2 Deployment on AWS

This project demonstrates how to deploy an Nginx web server on an EC2 instance using Terraform on AWS. The infrastructure includes:

- EC2 instance running Ubuntu
- Security Group allowing HTTP and SSH
- User data script to install and start Nginx
- Public IP output to access the deployed web server

## 📁 Project Structure
---
terraform-nginx-ubuntu/ 
├── main.tf        # Main Terraform configuration file. Defines EC2 instance and security group.
├── variables.tf   # Declares input variables like AMI ID, instance type, and key name.
├── outputs.tf     # Specifies outputs like the public IP of the EC2 instance.
├── README.md      # Documentation file with setup and deployment instructions.

---
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

  ![image](https://github.com/user-attachments/assets/4c073297-02da-49f4-8615-ec804019a44b)

      
(ii) Plan the Deployment:

      terraform plan

![image](https://github.com/user-attachments/assets/855527e3-3657-413c-87a8-596133646803)

      
(iii) Apply the Configuration:

      terraform apply
      
    ## Type 'yes' when prompted

  ![image](https://github.com/user-attachments/assets/b9f7f4a9-189a-4edd-a144-ac43c57af276)

  ![image](https://github.com/user-attachments/assets/53ef36af-9816-46bb-822f-06902d2f1768)

  ![image](https://github.com/user-attachments/assets/5665966b-9a24-4179-be0a-8caa2b19ad89)

  ![image](https://github.com/user-attachments/assets/b6bc556d-4cd5-4b44-a485-ddaaec91f8ad)


(iv) Get the Public IP:

        terraform output
        
        Access Nginx in Browser
        
        Navigate to http://<instance_public_ip>
        Example: http://44.212.33.180

  ![image](https://github.com/user-attachments/assets/0959a251-860b-4d0a-b364-4ee42a80726e)

  ![image](https://github.com/user-attachments/assets/3ffc17af-5212-41e1-8f40-ab1e57f0a250)

  ![image](https://github.com/user-attachments/assets/1bf3b4af-bd82-44cd-88e5-1e33eab06938)

  ![image](https://github.com/user-attachments/assets/d86c4e2b-2c48-4213-b40e-666e656417c7)


(v) To destroy all resources:

    terraform destroy

  ![image](https://github.com/user-attachments/assets/88debb45-30d1-4e58-81d8-086ebb987f0b)

  ![image](https://github.com/user-attachments/assets/463e784c-e2d2-4889-a0b6-808b57cce657)

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



