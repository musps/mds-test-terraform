output "aws_instance__instance-ursho__public_ip" {
  value = "${aws_instance.instance-ursho.public_ip}"
}

output "aws_instance__instance-ursho__private_ip" {
  value = "${aws_instance.instance-ursho.private_ip}"
}

output "aws_instance__bastion-instance__public_ip" {
  value = "${aws_instance.bastion-instance.public_ip}"
}

output "aws_instance__bastion-instance__private_ip" {
  value = "${aws_instance.bastion-instance.private_ip}"
}

output "aws_eip__ip-test-env__public_ip" {
  value = "${aws_eip.ip-test-env.public_ip}"
}

output "aws_db_instance__default__endpoint" {
  value = "${aws_db_instance.default.endpoint}"
}

output "aws_db_instance__default__address" {
  value = "${aws_db_instance.default.address}"
}