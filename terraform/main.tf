provider "aws" {
  region = "eu-central-1"
  version = "~> 2.11.0"
}

module "default" {
  source = "./module"

  db_password       = "!U[=nnP[6Kxg~d3?"
  ami_id            = "ami-0bcf9de6653ba7bc4"
  public_key_path   = "~/.ssh/id_rsa.pub"
  private_key_path  = "~/.ssh/id_rsa"
}
