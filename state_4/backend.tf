terraform {
  backend "s3" {
    bucket = "towsif-s3demo-xyz"
    region = "eu-north-1"
    key = "towsif/terraform.tfstate"
    dynamodb_table = "terraform_lock"
  }
}