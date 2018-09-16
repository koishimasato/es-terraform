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

resource "aws_instance" "elasticsearch" {
  count = "1"
  ami           = "ami-06cd52961ce9f0d85" # amazon linux
  instance_type = "t2.micro"
  key_name      = "terraform"
  security_groups = ["elasticsearch"]
  iam_instance_profile = "ec2-discovery"
  tags {
    Name = "elasticsearch-${count.index + 1}"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.elasticsearch.id}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

