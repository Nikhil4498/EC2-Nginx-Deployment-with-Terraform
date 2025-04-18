variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name to access the instance"
  default     = "Ralph-B8"  # Replace with your actual EC2 key pair name
}