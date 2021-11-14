resource "aws_vpc" "device_api" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Environment" = var.environment,
    "Cluster" = var.cluster_name,
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  }
}

resource "aws_subnet" "device_api" {
  count = 3
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.device_api.id

  tags = {
    "Environment" = var.environment,
    "Cluster" = var.cluster_name,
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  }
}

resource "aws_internet_gateway" "device_api" {
  vpc_id = aws_vpc.device_api.id

  tags = {
    "Environment" = var.environment,
    "Cluster" = var.cluster_name,
  }
}

resource "aws_route_table" "device_api" {
  vpc_id = aws_vpc.device_api.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.device_api.id
  }

  tags = {
    "Environment" = var.environment,
    "Cluster" = var.cluster_name,
  }
}

resource "aws_route_table_association" "device_api" {
  count = 3
  subnet_id      = aws_subnet.device_api.*.id[count.index]
  route_table_id = aws_route_table.device_api.id
}
