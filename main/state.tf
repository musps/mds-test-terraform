terraform {
  backend "s3" {
    bucket = "mds-mai"
    encrypt = true
    key    = "main-eu-central-1/terraform.state"
    region = "eu-central-1"
  }
}