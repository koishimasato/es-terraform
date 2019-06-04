resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-${var.stage}"
}

resource "aws_cloudwatch_log_group" "fargate_task_log" {
  name = "/ecs/fargate/task"
  retention_in_days = 14
}

