resource "aws_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "Prototype VPC"
  }
}

resource "aws_subnet" "app_subnet_a" {
  vpc_id = "${aws_vpc.app.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "app_subnet_b" {
  vpc_id = "${aws_vpc.app.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}c"
  tags {
    Name = "Public Subnet B"
  }
}

resource "aws_internet_gateway" "app" {
  vpc_id = "${aws_vpc.app.id}"

  tags {
    Name = "Prototype Internet Gateway"
  }
}

resource "aws_route_table" "app" {
  vpc_id = "${aws_vpc.app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app.id}"
  }

  tags {
    Name = "Prototype Route Table"
  }
}

resource "aws_route_table_association" "app_a_table" {
  subnet_id = "${aws_subnet.app_subnet_a.id}"
  route_table_id = "${aws_route_table.app.id}"
}

resource "aws_route_table_association" "app_subnet_b" {
  subnet_id = "${aws_subnet.app_subnet_b.id}"
  route_table_id = "${aws_route_table.app.id}"
}
