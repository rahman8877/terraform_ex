provider "aws" {
  region = "eu-north-1"
}

variable "ami" {
  description = "This is the AMI for the instance"
}

variable "instance_type" {
  description = "This is the AMI for the instance, for example t3.micro"
}


resource "aws_instance" "towsif" {
  //instance_type = "t3.micro"
  ami = var.ami
  instance_type = var.instance_type
  //subnet_id = "subnet-01008d43335bc48d2"
}