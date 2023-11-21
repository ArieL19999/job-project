
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

resource "aws_eip" "my_eip" {
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.my_eip.id
}

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

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "arielsVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.route.id
}


resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subnet"
  }

}

resource "aws_subnet" "private_sub" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_Subnet"
  }
}





