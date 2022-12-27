
resource "aws_subnet" "myapp-subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
     Name = "${var.env_prefix}-subent-1"
  }
}

# create a new route table and internet gateway

resource "aws_route_table" "myapp-route-table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-route-table"
  }

}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env_prefix}-internet-gateway"
  }
}

resource "aws_route_table_association" "a-rtb-subent" {
  subnet_id = aws_subnet.myapp-subnet.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.default_route_table_id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-route-table"
  }
}
