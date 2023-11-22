
# Defining an AWS EC2 instance resource
resource "aws_instance" "instance" {
  ami                     = "ami-0669b163befffbdfc"
  instance_type           = "t2.large"
  subnet_id               = aws_subnet.public_sub.id
  vpc_security_group_ids  = [aws_security_group.instance_sg.id]
  user_data              = base64encode(file("userdata.sh"))

  tags = {
    Name = "MyInstance"
  }
}

# Allocate an Elastic IP (EIP) for the instance
resource "aws_eip" "my_eip" {
}

# Associate the EIP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.my_eip.id
}

# Associate the EIP with the EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for Kubernetes EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group"
  }

}

# Defining an AWS VPC resource
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "arielsVPC"
  }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Define a route table for the VPC
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.route.id
}

# public subnet within the VPC
resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subnet"
  }

}

# private subnet within the VPC
resource "aws_subnet" "private_sub" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_Subnet"
  }
}





