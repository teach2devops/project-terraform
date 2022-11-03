provider "aws" {
  region = "ap-south-1"
}

# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "devops" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "devops"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "devops-public-1" {
  vpc_id                  = aws_vpc.devops.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "devops-public-1"
  }
}

resource "aws_subnet" "devops-public-2" {
  vpc_id                  = aws_vpc.devops.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "devops-public-2"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "devops-gw" {
  vpc_id = aws_vpc.devops.id

  tags = {
    Name = "devops"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "devops-public" {
  vpc_id = aws_vpc.devops.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-gw.id
  }

  tags = {
    Name = "devops-public-1"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "devops-public-1-a" {
  subnet_id      = aws_subnet.devops-public-1.id
  route_table_id = aws_route_table.devops-public.id
}

resource "aws_route_table_association" "devops-public-2-a" {
  subnet_id      = aws_subnet.devops-public-2.id
  route_table_id = aws_route_table.devops-public.id
}


# Creating EC2 instances in public subnets
resource "aws_instance" "public_inst_1" {
  ami           = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.devops-public-1.id}"
  key_name = "pre"
  tags = {
    Name = "public_inst_1"
  }
}

resource "aws_instance" "public_inst_2" {
  ami           = "ami-062df10d14676e201"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.dev-public-2.id}"
  key_name = "pre"
  tags = {
    Name = "public_inst_2"
  }
}
