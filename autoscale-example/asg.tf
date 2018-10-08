resource "aws_autoscaling_policy" "rails5-sample-asg-cpu-policy" {
  name                   = "rails5-sample-asg-cpu-policy"
  adjustment_type        = "PercentChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = "${aws_autoscaling_group.rails5-sample-autoscale-group.name}"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}

resource "aws_autoscaling_group" "rails5-sample-autoscale-group" {
    desired_capacity          = 1
    health_check_grace_period = 60
    health_check_type         = "ELB"
    launch_configuration      = "rails5-sample-autoscale-2"
    max_size                  = 3
    min_size                  = 1
    name                      = "rails5-sample-autoscale-group"
    vpc_zone_identifier       = ["subnet-05a3eef07771a5a4e", "subnet-0be4902b9f2101452"]
    target_group_arns = ["${aws_lb_target_group.rails5-sample-listener.arn}"]
    force_delete              = true

    tag {
        key   = "Name"
        value = "rails-sample-auto-scale"
        propagate_at_launch = true
    }

    depends_on = ["aws_launch_configuration.rails5-sample-autoscale-2"]

}

