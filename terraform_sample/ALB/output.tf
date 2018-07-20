output "fqdn"{
  value = "${aws_lb.test.dns_name}"

}