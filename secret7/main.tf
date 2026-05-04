provider "aws" {
  region = "eu-north-1"
}

provider "vault" {
  address  = "http://56.228.33.255:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "c6d18875-d020-67a0-4322-236c9b855ef6"
      secret_id = "3a3f6c9a-516e-781a-009e-c188ef684244"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "mv" 
  name  = "test-secret"
}

resource "aws_instance" "example" {
  instance_type = "t3.micro"
  ami = "ami-080254318c2d8932f"
  //subnet_id = "subnet-01008d43335bc48d2"


tags = {
  secret = data.vault_kv_secret_v2.example.data["username"]
}
}

/*resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}*/