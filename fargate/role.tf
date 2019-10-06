data "aws_caller_identity" "current" {}

resource "aws_iam_role" "task_role" {
  name               = "${var.task_name}-${var.stage}"
  assume_role_policy = "${data.aws_iam_policy_document.task_role_assume_role_policy_document.json}"
}

# assigns the app policy
resource "aws_iam_role_policy" "task_policy" {
  name   = "${var.task_name}-${var.stage}"
  role   = "${aws_iam_role.task_role.id}"
  policy = "${data.aws_iam_policy_document.task_policy_document.json}"
}

# TODO: fill out custom policy
data "aws_iam_policy_document" "task_policy_document" {
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
data "aws_iam_policy_document" "task_role_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_role_policy_document.json}"
}

data "aws_iam_policy_document" "ecs_tasks_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role = "${aws_iam_role.ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "events_role" {
  name               = "${var.task_name}-events"
  assume_role_policy = "${data.aws_iam_policy_document.events_assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "events_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "events_role_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.app.family}:*"]

    condition {
      test     = "StringLike"
      variable = "ecs:cluster"
      values   = [aws_ecs_cluster.ecs_cluster.arn]
    }
  }
}

resource "aws_iam_role_policy" "events_role_policy" {
  name   = "${var.task_name}-${var.stage}-events-ecs"
  role   = aws_iam_role.events_role.id
  policy = data.aws_iam_policy_document.events_role_policy_document.json
}

# allow events role to pass role to task execution role and app role
data "aws_iam_policy_document" "pass_role" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]

    resources = [
      aws_iam_role.task_role.arn,
      aws_iam_role.ecs_task_execution_role.arn,
    ]
  }
}

resource "aws_iam_role_policy" "pass_role_policy" {
  name   = "${var.task_name}-${var.stage}-events-ecs-passrole"
  role   = aws_iam_role.events_role.id
  policy = data.aws_iam_policy_document.pass_role.json
}

