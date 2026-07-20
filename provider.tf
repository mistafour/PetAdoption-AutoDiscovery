provider "aws" {
  region  = "eu-west-3"
  # profile = "default"
}

terraform {
  backend "s3" {
    bucket       = "pet-adoption-state-bucket-one-pet"
    #use_lockfile = false
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    dynamodb_table = "pet-adoption-state-bucket-one-dynamodb-lock-pet"
    # profile      = "default"
  }
}

provider "vault" {
  address = "vault address"
  token   = "vault token"
}
