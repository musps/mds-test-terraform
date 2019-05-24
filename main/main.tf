provider "aws" {
  region = "${var.region}"
  version = "~> 2.11.0"
}

resource "aws_key_pair" "default" {
  key_name   = "test10"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_vpc" "main" {
  cidr_block           = "172.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "main" {
  availability_zone = "eu-central-1a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.2.1.0/24"
  tags = {
    Name = "Main subnet"
  }
}

resource "aws_subnet" "second" {
  availability_zone = "eu-central-1b"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.2.2.0/24"
  tags = {
    Name = "Main subnet"
  }
}

resource "aws_db_subnet_group" "toto" {
  name       = "main"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.second.id}"]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "first" {
  name        = "first"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "second" {
  name        = "second"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  skip_final_snapshot  = true
  allocated_storage    = 20
  storage_type         = "gp2"
  instance_class       = "db.t2.micro"
  name                 = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  port                 = "${var.db_port}"
  engine               = "postgres"
  engine_version       = "9.6.3"
  db_subnet_group_name   = "${aws_db_subnet_group.toto.id}"
  vpc_security_group_ids = ["${aws_security_group.first.id}"]
}

resource "aws_instance" "instance-ursho" {
  ami             = "${var.ami_id}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.default.key_name}"
  security_groups = ["${aws_security_group.first.id}"]
  subnet_id       = "${aws_subnet.main.id}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/files/bastion_data.sh")}"

  vars {
    ssh_user        = "${var.ssh_user}"
    ssh_private_key = "${file("~/.ssh/id_rsa")}}"
  }
}

data "template_file" "ursho_data" {
  template = "${file("${path.module}/files/ursho_data.sh")}"

  vars {
    ssh_user        = "${var.ssh_user}"
  }
}

resource "aws_instance" "bastion-instance" {
  ami             = "${var.ami_id}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.default.key_name}"
  security_groups = ["${aws_security_group.second.id}"]
  subnet_id       = "${aws_subnet.second.id}"
  user_data       = "${data.template_file.user_data.rendered}"
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.bastion-instance.id}"
  vpc      = true
}

resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "test-env-gw"
  }
}


resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-env-gw.id}"
  }
  tags {
    Name = "test-env-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.second.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}
