#variable for vpc cidr block
variable "wordpressapp-vpc-cidr" {
  type        = string
  description = "This is the cidr block of vpc"
  default     = "10.0.0.0/16"
}

#variable for public web subnet cidr block for AZ 2a
variable "publicALBNAT1subcidr" {
  type        = string
  description = "This is the public subnet cidr block for web 1"
  default     = "10.0.2.0/24"
}

#variable for public web subnet cidr block for AZ 2b
variable "publicALBNAT2subcidr" {
  type        = string
  description = "This is the public subnet cidr block for web 2"
  default     = "10.0.3.0/24"
}

#variable for private DB subnet cidr block for AZ 2a
variable "privateweb1subcidr" {
  type        = string
  description = "This is the private subnet cidr block for DB 1"
  default     = "10.0.4.0/24"
}

#variable for private DB subnet cidr block for AZ 2b
variable "privateweb2subcidr" {
  type        = string
  description = "This is the private subnet cidr block for DB 2"
  default     = "10.0.5.0/24"
}

#variable for private DB subnet cidr block for AZ 2a
variable "privatedb1subcidr" {
  type        = string
  description = "This is the private subnet cidr block for DB 1"
  default     = "10.0.7.0/24"
}

#variable for private DB subnet cidr block for AZ 2b
variable "privatedb2subcidr" {
  type        = string
  description = "This is the private subnet cidr block for DB 2"
  default     = "10.0.6.0/24"
}

#variable for AZ 2a
variable "AZ2a" {
  type        = string
  description = "This is the AZ for us-east-1a"
  default     = "eu-west-1a"
}

#variable for AZ 2b
variable "AZ2b" {
  type        = string
  description = "This is the AZ for AZ us-east-1b"
  default     = "eu-west-1b"
}

#variables for instance
variable "ami_instance" {
  type = string
  description = "This is the AMI for our Instance"
  default = "ami-0ea0f26a6d50850c5"
}

#variables for instance 
variable "instance_type" {
  type = string 
  description = "This is the instance_type for our instance"
  default = "t2.medium" 
}

#variable for username
variable "DBusername" {
type = string
default = "admin@admin"
}

#varible for password
variable "DBpassword" {
  type = string
  default = "admin@admin"
}

#variable for DB instance_class
variable "DB_instance_class" {
  type = string
  default = "db.t3.micro"
}

#variable for engine_type
variable "engine_type" {
  type = string
  default = "mysql"
}

#variable for DB_storage
variable "DB_storage" {
  type = string
  default = "30"
}

  
