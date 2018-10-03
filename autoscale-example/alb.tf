resource "aws_alb" "rails5-sample-alb" {
    idle_timeout    = 60
    internal        = false
    name            = "rails5-sample-alb"
    security_groups = ["sg-057136931c2c00238"]
    subnets         = ["subnet-05a3eef07771a5a4e", "subnet-0be4902b9f2101452"]

    enable_deletion_protection = false

    tags {
        "Name" = "rails5-sample-alb"
    }
}

resource "aws_lb_target_group" "rails5-sample-listener" {
  name = "rails5-sample-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-0bda8c080ab37b85a"
}

resource "aws_lb_listener" "rails5-sample-listener" {
  load_balancer_arn = "${aws_alb.rails5-sample-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.rails5-sample-listener.arn}"
  }
}
