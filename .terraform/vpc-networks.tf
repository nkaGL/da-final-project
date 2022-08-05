resource "aws_vpc" "vpc-dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    name = "vpc-prod"
  }
}
resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.vpc-dev.id
  tags = {
    name = "dev"
  }
}

resource "aws_eip" "nat-ip-dev" {
  vpc = true
  tags = {
    name = "nat-ip-dev"
  }
}

resource "aws_nat_gateway" "nat-dev" {
  allocation_id = aws_eip.nat-ip-dev.id
  #subnet_id     = aws_subnet.public-subnet-dev-a.id
  tags = {
    name = "nat-dev"
  }
  depends_on = [aws_internet_gateway.prod]
}
