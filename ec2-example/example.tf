provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_s3_bucket" "example" {
  bucket = "terraform-getting-started-guide-umeneri-2018-08-25"
  acl    = "private"
}

resource "aws_instance" "example" {
  # amazon linux
  ami           = "ami-08847abae18baa040"
  instance_type = "t2.micro"
  key_name      = "terraform"
  depends_on = ["aws_s3_bucket.example"]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}


resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

