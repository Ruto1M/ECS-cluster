provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "Dami"
    bucket = "my-terraform-state100028927365"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terra_user_lock"
    encrypt = true
  }
}

