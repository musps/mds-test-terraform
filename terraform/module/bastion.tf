/****
* START ---- NETWORK
*/

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}

resource "aws_route_table" "bastion" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "bastion" {
  subnet_id      = "${aws_subnet.bastion.id}"
  route_table_id = "${aws_route_table.bastion.id}"
}

output "bastion_public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

/****
* END ---- NETWORK
*/

/****
* START ---- BASTION
*/

data "template_file" "bastion_data" {
  template = "${file("${path.module}/files/bastion_data.sh")}"

  vars {
    ssh_user        = "${var.ssh_user}"
    ssh_private_key = "${file("${var.private_key_path}")}}"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "${var.ami_id}"
  key_name                    = "${aws_key_pair.default.key_name}"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.bastion.id}"
  security_groups             = ["${aws_security_group.bastion.id}"]
  user_data                   = "${data.template_file.bastion_data.rendered}"
}

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/****
* END ---- BASTION
*/
