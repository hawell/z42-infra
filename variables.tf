variable "aws_region" {
   description = "AWS Region to launch servers"
}

variable "aws_access_key" {
   description = "AWS User Access Key"
}

variable "aws_secret_key" {
   description = "AWS User Secret Key"
}

variable "aws_amis" {
   default = {
       eu-west-3 = "ami-0afd55c0c8a52973a"
   }
}

variable "instance_type" {
   description = "Type of AWS EC2 instance."
   default     = "t2.micro"
}

variable "db_username" {
   description = "database master username"
   type        = string
   sensitive   = true
}

variable "db_password" {
   description = "databse master password"
   type        = string
   sensitive   = true
}

variable "recaptcha_key" {
   description = "recaptcha site key"
   type        = string
   sensitive   = true
}
