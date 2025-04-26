data "aws_vpc" "vpc_grupo_d" {
  id = "vpc-09706dbcf9fda1bc7"  # ID da sua VPC
}


resource "aws_subnet" "sn_pub01" {
  vpc_id = data.aws_vpc.vpc_grupo_d.id
  cidr_block = "172.102.3.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "grupo_d-sn_pub01"
  }
}


data "aws_internet_gateway" "igw" {
  filter {
  name = "tag:name"
  values = ["grupo_d-igw"]
}
}

resource "aws_route_table" "route_pub" {
  vpc_id = data.aws_vpc.vpc_grupo_d.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "grupo_d-routetable"
  }
}

resource "aws_route_table_association" "pub01assoc" {
  subnet_id = aws_subnet.sn_pub01.id
  route_table_id = aws_route_table.route_pub.id
}

