resource "aws_vpc" "primary" {
    cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.primary.id
  cidr_block = "10.20.0.0/18"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.primary.id
  cidr_block = "10.20.64.0/18"
  map_public_ip_on_launch = false
  availability_zone = "${var.region}a"
}

resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.primary.id
}

### Route Table Section ####
### Do not use aws_route resources with aws_route_table + route block, this will cause a race condition
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.primary.id

  route = {
    cidr_block = "0.0.0.0/0" # full public ingress
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

resource "aws_route_table_association" "public_route" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public.id
}

resource "aws_security_group" "public_sg" {
  name = "public-sg"
  description = "Enables public web ingress (HTTPS)"
  vpc_id = aws_vpc.primary.id
}

resource "aws_vpc_security_group_ingress_rule" "public_ingress_rule" {
  security_group_id = aws_security_group.public_sg.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_egress_rule" {
  ip_protocol = "-1" # Specifying all protocols - just in case
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}