/****
* START ---- NETWORK
*/

resource "aws_eip" "ursho" {
  instance = "${aws_instance.ursho.id}"
  vpc      = true
}

resource "aws_route_table" "ursho" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "ursho" {
  subnet_id      = "${aws_subnet.ursho.id}"
  route_table_id = "${aws_route_table.ursho.id}"
}

output "ursho_public_ip" {
  value = "${aws_eip.ursho.public_ip}"
}

output "ursho_private_ip" {
  value = "${aws_instance.ursho.private_ip}"
}

/****
* END ---- NETWORK
*/

/****
* START ---- URSHO
*/

data "template_file" "ursho_data" {
  template = "${file("${path.module}/files/ursho_data.sh")}"

  vars {
    ssh_user    = "${var.ssh_user}"
    db_host     = "${aws_db_instance.ursho.address}"
    db_name     = "${var.db_name}"
    db_port     = "${var.db_port}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
    app_port    = "${var.app_port}"
  }
}

resource "aws_db_subnet_group" "ursho" {
  subnet_ids = ["${aws_subnet.bastion.id}", "${aws_subnet.ursho.id}"]
}

resource "aws_security_group" "ursho" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["${var.cird_block_main}"]
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["${var.cird_block_main}"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "ursho" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6"
  instance_class         = "db.t2.micro"
  name                   = "${var.db_name}"
  username               = "${var.db_username}"
  password               = "${var.db_password}"
  port                   = "${var.db_port}"
  db_subnet_group_name   = "${aws_db_subnet_group.ursho.id}"
  vpc_security_group_ids = ["${aws_security_group.ursho.id}"]
  skip_final_snapshot    = true
}

resource "aws_instance" "ursho" {
  ami             = "${var.ami_id}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.default.key_name}"
  subnet_id       = "${aws_subnet.ursho.id}"
  security_groups = ["${aws_security_group.ursho.id}"]
  user_data       = "${data.template_file.ursho_data.rendered}"
}

/****
* END ---- URSHO
*/
