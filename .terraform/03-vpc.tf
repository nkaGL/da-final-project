# Create a VPC
resource "aws_vpc" "projectdev" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
   tags = {
    Name = "projectdev"
  }
}

# Subnets
resource "aws_subnet" "projectdev-subnet-public1-eu-west-1a" {
    vpc_id            = aws_vpc.projectdev.id
    cidr_block        = "10.0.10.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
  tags = {
    Name = "projectdev-subnet"
  }
}
resource "aws_subnet" "projectdev-subnet-private1-eu-west-1a" {
    vpc_id            = aws_vpc.projectdev.id
    cidr_block        = "10.0.0.0/24"
    availability_zone = "eu-west-1a"
  tags = {
    Name = "projectdev-subnet"
  }
}
resource "aws_subnet" "projectdev-subnet-public1-eu-west-1b" {
    vpc_id            = aws_vpc.projectdev.id
    cidr_block        = "10.0.11.0/24"
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = true
  tags = {
    Name = "projectdev-subnet"
  }
}
resource "aws_subnet" "projectdev-subnet-private2-eu-west-1b" {
    vpc_id            = aws_vpc.projectdev.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "eu-west-1b"
  tags = {
    Name = "projectdev-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "projectdev-igw" {
  vpc_id = aws_vpc.projectdev.id
  tags = {
    Name = "projectdev-igw"
  }
}

# Route Tables
resource "aws_route_table" "projectdev-rtb-public" {
  vpc_id = aws_vpc.projectdev.id

  route = [{
    cidr_block                 = "0.0.0.0/0"
    gateway_id                 = aws_internet_gateway.projectdev-igw.id
    carrier_gateway_id         = ""
    core_network_arn           = ""
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    instance_id                = ""
    ipv6_cidr_block            = null
    local_gateway_id           = ""
    nat_gateway_id             = ""
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    Name = "projectdev-rtb-public"
  }
}

resource "aws_route_table_association" "projectdev-rtb-public-association-a" {
  subnet_id      = aws_subnet.projectdev-subnet-public1-eu-west-1a.id
  route_table_id = aws_route_table.projectdev-rtb-public.id
}

resource "aws_route_table_association" "projectdev-rtb-public-association-b" {
  subnet_id      = aws_subnet.projectdev-subnet-public1-eu-west-1b.id
  route_table_id = aws_route_table.projectdev-rtb-public.id
}
