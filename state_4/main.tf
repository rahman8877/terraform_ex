provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "towsif" {
  instance_type = "t3.micro"
  ami = "ami-080254318c2d8932f"
  subnet_id = "subnet-01008d43335bc48d2"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "towsif-s3demo-xyz"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name             = "terraform-lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  

  attribute {
    name = "LockID"
    type = "S"
  }
}