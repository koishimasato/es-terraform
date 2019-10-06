resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.task_name}-${var.stage}"
}

variable "log_group" {
  default = "/ecs/fargat/task"
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.task_name}"
  requires_compatibilities = [
    "FARGATE"
  ]
  network_mode = "awsvpc"
  cpu = "256"
  memory = "512"
  execution_role_arn = "${aws_iam_role.ecs_task_execution_role.arn}"
  task_role_arn = "${aws_iam_role.task_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.task_name}-${var.stage}",
    "image": "772010606571.dkr.ecr.ap-northeast-1.amazonaws.com/ls-test:latest",
    "essential": true,
    "portMappings": [],
    "environment": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${var.log_group}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "fargate"
      }
    }
 }
]
DEFINITION
}

resource "aws_cloudwatch_log_group" "fargate_task_log" {
  name = "${var.log_group}"
  retention_in_days = 14
}

resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "${var.task_name}"
  description         = "Runs fargate task ${var.task_name}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "scheduled_task" {
  target_id = "${var.task_name}"
  rule = "${aws_cloudwatch_event_rule.scheduled_task.name}"
  arn = "${aws_ecs_cluster.ecs_cluster.arn}"
  role_arn = "${aws_iam_role.events_role.arn}"
  input = "{}"

  ecs_target {
    task_count = 1
    task_definition_arn = "${aws_ecs_task_definition.app.arn}"
    launch_type = "FARGATE"
    platform_version = "LATEST"

    network_configuration {
      assign_public_ip = true
      security_groups = [
        "${aws_security_group.fargate_sg.id}"
      ]
      subnets = [
        "${aws_subnet.app_subnet_a.id}",
        "${aws_subnet.app_subnet_c.id}"
      ]
    }
  }

//  # allow the task definition to be managed by external ci/cd system
//  lifecycle {
//    ignore_changes = [
//      "ecs_target.0.task_definition_arn"
//    ]
//  }
}

