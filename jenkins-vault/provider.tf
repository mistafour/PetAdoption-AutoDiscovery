# create aws provider
provider "aws" {
  region  = var.region
  profile = "default"
}
terraform {
  backend "s3" {
    bucket         = "pet-adoption-state-bucket-one-pet"
    key            = "vault-jenkins/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "pet-adoption-state-bucket-one-dynamodb-lock-pet"
    profile        = "default"
  }
}