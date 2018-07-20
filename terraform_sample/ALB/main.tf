resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.subnets}"]
  #security_groups   =  ["${var.sg_lb}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  access_logs {
    bucket = "${var.bucketname}"
    enabled = true
  }
  tags {
    Environment = "production"
  }
}
resource "aws_lb_target_group" "TG" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
  health_check {
  port = "80"
  protocol= "TCP"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.test.arn}"
  port              = "80"
  protocol          = "TCP"
 
  default_action {
    target_group_arn = "${aws_lb_target_group.TG.arn}"
    type             = "forward"
  }
}



resource "aws_lb_target_group_attachment" "TG_att" {
  count = "${var.instance_count}"
  target_group_arn = "${aws_lb_target_group.TG.arn}"
  target_id        = "${element(var.instances, count.index)}"
  port             = 80
}
