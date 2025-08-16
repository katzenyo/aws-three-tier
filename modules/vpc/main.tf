resource "aws_vpc" "primary" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "dev-plan-vpc"
    }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.primary.id
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "private-app" {
  vpc_id = aws_vpc.primary.id
  cidr_block = var.private_apps_cidr
  map_public_ip_on_launch = false
  availability_zone = "${var.region}a"
  tags = {
    Name = "dev-plan-private-app-subnet"
    Purpose = "dev plan"
  }
}

resource "aws_subnet" "private-db" {
  vpc_id = aws_vpc.primary.id
  cidr_block = var.private_db_cidr
  map_public_ip_on_launch = false
  availability_zone = "${var.region}a"
  tags = {
    Name = "dev-plan-private-db-subnet"
    Purpose = "dev plan"
  }
}

### NAT and IGW's

resource "aws_eip" "nat_eip" {
  depends_on = [ aws_internet_gateway.gateway1,aws_nat_gateway.nat_gateway_1 ] # In case gateways must exist first
  network_interface = aws_nat_gateway.nat_gateway_1.allocation_id # attaching to NAT gateway using allocation_id
  domain = aws_vpc.primary
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.primary.id
  tags = {
    Name = "lab-igw"
    Purpose = "dev plan"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  subnet_id = aws_subnet.public.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "lab-nat-gw"
    Purpose = "dev plan"
  }
}


### Route Table Section ####

### Do not use aws_route resources with aws_route_table + route block, this will cause a race condition

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.primary.id

  route = {
    cidr_block = "0.0.0.0/0" # full public ingress
    gateway_id = aws_internet_gateway.igw1
  }

  tags = {
    Name = "dev-plan-route-table"
    Purpose = "dev plan"
  }
}

resource "aws_route_table_association" "public_route" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public.id
}