data "aws_caller_identity" "current" {}

resource "aws_iam_role" "app_role" {
  name               = "${var.name}-${var.stage}"
  assume_role_policy = "${data.aws_iam_policy_document.app_role_assume_role_policy.json}"
}

# assigns the app policy
resource "aws_iam_role_policy" "app_policy" {
  name   = "${var.name}-${var.stage}"
  role   = "${aws_iam_role.app_role.id}"
  policy = "${data.aws_iam_policy_document.app_policy.json}"
}

# TODO: fill out custom policy
data "aws_iam_policy_document" "app_policy" {
  statement {
    actions = [
      "ecs:DescribeClusters",
    ]

    resources = [
      "${aws_ecs_cluster.ecs_cluster.arn}",
    ]
  }
}

# allow role to be assumed by ecs and local saml users (for development)
data "aws_iam_policy_document" "app_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_role.json}"
}

data "aws_iam_policy_document" "ecs_tasks_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = "${aws_iam_role.ecs_task_execution.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "cloudwatch_events_role" {
  name               = "${var.name}-events"
  assume_role_policy = "${data.aws_iam_policy_document.events_assume_role_policy.json}"
}

data "aws_iam_policy_document" "events_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "events_ecs" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.app.family}:*"]

    condition {
      test     = "StringLike"
      variable = "ecs:cluster"
      values   = ["${aws_ecs_cluster.ecs_cluster.arn}"]
    }
  }
}

resource "aws_iam_role_policy" "events_ecs" {
  name   = "${var.name}-${var.stage}-events-ecs"
  role   = "${aws_iam_role.cloudwatch_events_role.id}"
  policy = "${data.aws_iam_policy_document.events_ecs.json}"
}

# allow events role to pass role to task execution role and app role
data "aws_iam_policy_document" "passrole" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]

    resources = [
      "${aws_iam_role.app_role.arn}",
      "${aws_iam_role.ecs_task_execution.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "events_ecs_passrole" {
  name   = "${var.name}-${var.stage}-events-ecs-passrole"
  role   = "${aws_iam_role.cloudwatch_events_role.id}"
  policy = "${data.aws_iam_policy_document.passrole.json}"
}

