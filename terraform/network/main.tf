resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone       = var.av_zone1
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform-subnet-public"
  }
}

resource "aws_subnet" "prod-subnet-private-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = var.av_zone2
  tags = {
    Name = "terraform-subnet-private"
  }
}

resource "aws_subnet" "rds-subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.3.0/24"

  availability_zone       = var.av_zone1
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform-subnet-rds-1"
  }
}

resource "aws_subnet" "rds-subnet-2" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.4.0/24"

  availability_zone       = var.av_zone2
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform-subnet-rds-2"
  }
}

resource "aws_security_group" "default-security-group" {
  name   = "terraform-security-group"
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
}

resource "aws_security_group" "rds-security-group" {
  name = "rds-terraform-security-group"


  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]

  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "private-nat-gw"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "public-igw"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.prod-subnet-public-1.id
}

resource "aws_route" "rt-pub" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.all_cidr
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta-pub" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "route-table-priv" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "route-table-priv"
  }
}

resource "aws_route" "rt-priv" {
  route_table_id         = aws_route_table.route-table-priv.id
  destination_cidr_block = var.all_cidr
  gateway_id             = aws_nat_gateway.nat-gw.id

}

resource "aws_route_table_association" "rta-priv" {
  subnet_id      = aws_subnet.prod-subnet-private-1.id
  route_table_id = aws_route_table.route-table-priv.id

}
