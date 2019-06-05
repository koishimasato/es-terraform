provider "aws" {
  region     = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "es-fargate"
    key    = "es-fargate.tfstate"
    region     = "ap-northeast-1"
    profile = "terraform"
  }
}

variable aws_profile { default = "terraform" }
//variable "access_key" {}
//variable "secret_key" {}
variable "region" {
  default = "ap-northeast-1"
}

variable "name" {
  default = "ls-test"
}
variable "stage" {
  default = "staging"
}

variable "schedule_expression" {
  default = "rate(5 minutes)"
}

variable "private_subnets" {
  default = ""
}


