provider "aws" {
  profile = "terraform"
  region     = "${var.region}"
}

resource "aws_instance" "rails-sample-auto-scale" {
    ami                         = "ami-0ac73d6e40cc840eb"
    availability_zone           = "ap-northeast-1c"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    monitoring                  = false
    key_name                    = "terraform"
    subnet_id                   = "subnet-05a3eef07771a5a4e"
    vpc_security_group_ids      = ["sg-0c52b7c7aa475e4a6"]
    associate_public_ip_address = true
    private_ip                  = "10.0.1.191"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }

    tags {
        "aws:autoscaling:groupName" = "rails5-sample-autoscale-group"
        "Name" = "rails-sample-auto-scale"
    }
}
