provider "aws" {
  region = "eu-central-1"
  version = "~> 2.11.0"
}

resource "aws_key_pair" "default" {
  key_name   = "test10"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.cird_block_main}"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "bastion" {
  availability_zone = "eu-central-1a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.cird_block_bastion}"
}

resource "aws_subnet" "ursho" {
  availability_zone = "eu-central-1b"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.cird_block_ursho}"
}
