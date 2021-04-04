variable "stage" {}
variable "vpc_cidr" {}

resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.stage}-vpc"
  }
}

resource "aws_subnet" "subnet_public_1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stage}-subnet-public-1c"
  }
}

resource "aws_subnet" "subnet_public_1d" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  availability_zone = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stage}-subnet-public-1d"
  }
}

resource "aws_subnet" "subnet_private_1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.stage}-subnet-private-1c"
  }
}

resource "aws_subnet" "subnet_private_1d" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 3)
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "${var.stage}-subnet-private-1d"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.stage}-igw"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.stage}-rtb-public"
  }
}

resource "aws_route_table_association" "rtb_assoc_public_1c" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id      = aws_subnet.subnet_public_1c.id
}

resource "aws_route_table_association" "rtb_assoc_public_1d" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id      = aws_subnet.subnet_public_1d.id
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.rtb_public]
}

resource "aws_eip" "eip_natgw_c" {
  vpc = true
  tags = {
    Name = "${var.stage}-eip-natgw-c"
  }
}

resource "aws_eip" "eip_natgw_d" {
  vpc = true
  tags = {
    Name = "${var.stage}-eip-natgw-d"
  }
}

resource "aws_nat_gateway" "natgw_c" {
  allocation_id = aws_eip.eip_natgw_c.id
  subnet_id     = aws_subnet.subnet_public_1c.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.stage}-natgw-c"
  }
}

resource "aws_nat_gateway" "natgw_d" {
  allocation_id = aws_eip.eip_natgw_d.id
  subnet_id     = aws_subnet.subnet_public_1d.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.stage}-natgw-d"
  }
}

resource "aws_route_table" "rtb_private_1c" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_c.id
  }

  tags = {
    Name = "${var.stage}-rtb-private-1c"
  }
}

resource "aws_route_table" "rtb_private_1d" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_d.id
  }

  tags = {
    Name = "${var.stage}-rtb-private-1d"
  }
}

resource "aws_route_table_association" "rtb_assoc_private_1c" {
  route_table_id = aws_route_table.rtb_private_1c.id
  subnet_id      = aws_subnet.subnet_private_1c.id
}

resource "aws_route_table_association" "rtb_assoc_private_1d" {
  route_table_id = aws_route_table.rtb_private_1d.id
  subnet_id      = aws_subnet.subnet_private_1d.id
}

output vpc_id {
  value = aws_vpc.vpc.id
}
output cidr {
  value = aws_vpc.vpc.cidr_block
}
output public_subnet_ids {
  value = [aws_subnet.subnet_public_1c.id, aws_subnet.subnet_public_1d.id]
}
output private_subnet_ids {
  value = [aws_subnet.subnet_private_1c.id, aws_subnet.subnet_private_1d.id]
}

output private_subnet_id_c {
  value = aws_subnet.subnet_private_1c.id
}

output private_subnet_id_d {
  value = aws_subnet.subnet_private_1d.id
}