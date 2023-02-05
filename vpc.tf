#Create VPC
resource "aws_vpc" "clixxvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name       = "clixxvpc"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Create subnets
resource "aws_subnet" "pubsub1" {
  vpc_id            = aws_vpc.clixxvpc.id
  cidr_block        = "10.0.0.0/23"
  availability_zone = "us-east-1a"

  tags = {
    Name       = "pubsub1"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

resource "aws_subnet" "pubsub2" {
  vpc_id            = aws_vpc.clixxvpc.id
  cidr_block        = "10.0.2.0/23"
  availability_zone = "us-east-1b"

  tags = {
    Name       = "pubsub2"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Private subnets
resource "aws_subnet" "privsub1" {
  vpc_id            = aws_vpc.clixxvpc.id
  cidr_block        = "10.0.4.0/25"
  availability_zone = "us-east-1a"

  tags = {
    Name       = "privsub1"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

resource "aws_subnet" "privsub2" {
  vpc_id            = aws_vpc.clixxvpc.id
  cidr_block        = "10.0.4.128/25"
  availability_zone = "us-east-1b"

  tags = {
    Name       = "privsub2"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

resource "aws_subnet" "privsub3" {
  vpc_id            = aws_vpc.clixxvpc.id
  cidr_block        = "10.0.8.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name       = "privsub3"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

resource "aws_subnet" "privsub4" {
  vpc_id            = aws_vpc.clixxvpc.id
  cidr_block        = "10.0.12.0/22"
  availability_zone = "us-east-1b"

  tags = {
    Name       = "privsub4"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "clixxigw" {
  vpc_id = aws_vpc.clixxvpc.id

  tags = {
    Name       = "clixxigw"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Create Elastic IP addresses
resource "aws_eip" "clixxeip1" {
  vpc = true
}

resource "aws_eip" "clixxeip2" {
  vpc = true
}

#Create public subnet NAT gateways
resource "aws_nat_gateway" "clixxnat1" {
  allocation_id = aws_eip.clixxeip1.id
  subnet_id     = aws_subnet.pubsub1.id

  tags = {
    Name       = "clixxnat1"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }

  depends_on = [aws_internet_gateway.clixxigw]
}

resource "aws_nat_gateway" "clixxnat2" {
  allocation_id = aws_eip.clixxeip2.id
  subnet_id     = aws_subnet.pubsub2.id

  tags = {
    Name       = "clixxnat2"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }

  depends_on = [aws_internet_gateway.clixxigw]
}

#Create public subnet Route Table
resource "aws_route_table" "clixxpubroute" {
  vpc_id = aws_vpc.clixxvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.clixxigw.id
  }

  tags = {
    Name       = "clixxpubroute"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Associate public subnets to public route rable
resource "aws_route_table_association" "clixxpubsub-assoc1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.clixxpubroute.id
}

resource "aws_route_table_association" "clixxpubsub-assoc2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.clixxpubroute.id
}

#Create private subnet Route Table zone 1a
resource "aws_route_table" "clixxprivroute1" {
  vpc_id = aws_vpc.clixxvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.clixxnat1.id
  }

  tags = {
    Name       = "clixxprivroute1"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Create private subnet Route Table zone 1b
resource "aws_route_table" "clixxprivroute2" {
  vpc_id = aws_vpc.clixxvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.clixxnat2.id
  }

  tags = {
    Name       = "clixxprivroute2"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

#Associate private subnet to route rable
resource "aws_route_table_association" "clixxprivsub-assoc1" {
  subnet_id      = aws_subnet.privsub1.id
  route_table_id = aws_route_table.clixxprivroute1.id
}

#Create Endpoint
resource "aws_vpc_endpoint" "clixxendpoint" {
  vpc_id       = aws_vpc.clixxvpc.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Name       = "clixxendpoint"
    StackTeam  = "stackcloud9"
    Schedule   = "A"
    OwnerEmail = "mohamedxkamara@gmail.com"
    Backup     = "yes"
  }
}

resource "aws_vpc_endpoint_route_table_association" "clixxendpoint-assoc1" {
  route_table_id  = aws_route_table.clixxprivroute1.id
  vpc_endpoint_id = aws_vpc_endpoint.clixxendpoint.id
}

resource "aws_vpc_endpoint_route_table_association" "clixxendpoint-assoc2" {
  route_table_id  = aws_route_table.clixxprivroute2.id
  vpc_endpoint_id = aws_vpc_endpoint.clixxendpoint.id
}