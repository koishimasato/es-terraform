resource "aws_launch_configuration" "rails5-sample-autoscale-2" {
    name                        = "rails5-sample-autoscale-2"
    image_id                    = "ami-0ac73d6e40cc840eb"
    instance_type               = "t2.micro"
    key_name                    = "terraform"
    security_groups             = ["sg-0c52b7c7aa475e4a6"]
    associate_public_ip_address = true
    enable_monitoring           = false
    ebs_optimized               = false

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }

}

