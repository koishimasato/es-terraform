terraform {
  required_version = ">= 0.11.0"

  backend "s3" {
    bucket = "terraform-state-es"
    key    = "elasticsearch/terraform.tfstate.aws"
    region = "ap-northeast-1"
    profile = "terraform"
  }
}

provider "aws" {
  region = "ap-northeast-1"
//  profile = "${var.aws_profile}"
  profile = "terraform"
}

variable "node_count" { default = "1" }

resource "aws_instance" "elasticsearch" {
  count = "${var.node_count}"
  ami           = "ami-0a189ff34f347d253" # amazon linux
  instance_type = "t2.micro"
  key_name      = "terraform"
  security_groups = ["elasticsearch"]
  iam_instance_profile = "ec2-discovery"
  tags {
    Name = "elasticsearch-${count.index + 4}"
  }
}

resource "aws_eip" "ip" {
  count = "${var.node_count}"
  instance = "${element(aws_instance.elasticsearch.*.id, count.index)}"
  vpc = true
}
