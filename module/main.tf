provider "aws" {
  region = "eu-north-1"
}

variable "ami" {
  description = "This is the AMI for the instance"
}

variable "instance_type" {
  description = "This is the AMI for the instance, for example t3.micro"
  type = map(string)
  default = {
    "dev" = "t3.micro"
    "stage" = "t3.medium"
    "prod" = "t3.xlarge"
  }
}

module "ec2_instance" {
  source = "./ec2_instance"
  ami = var.ami
instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro")
}