terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
  backend "s3" {
  bucket = "terra-s3-234"
  key = "state/terraform.tfstate"
  region = "us-east-1"

}

}

provider "aws" {
  region = "us-east-1"
}
