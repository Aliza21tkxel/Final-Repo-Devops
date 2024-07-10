# Define provider and required versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"  # Adjust version range as needed
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key="
}

# VPC resource block
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-terraform"
    owners      = "aws"
    environment = "prod"
  }
}

# Public Subnet resource block
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1a"  # Specify your desired AZ

  tags = {
    Name = "vpc-terraform-public-subnet"
    owners      = "aws"
    environment = "prod"
  }
}

# Internet Gateway resource block
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vpc-terraform-igw"
    owners      = "aws"
    environment = "prod"
  }
}

# Route Table resource block
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "vpc-terraform-public-rt"
    owners      = "aws"
    environment = "prod"
  }
}

# Route Table Association resource block
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group resource block
resource "aws_security_group" "web_sg" {
  name        = "prod-web-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "prod-web-sg"
    owners      = "aws"
    environment = "prod"
  }
}

# EC2 Instance resource block
resource "aws_instance" "Terraform-ec2" {
  ami                    = "ami-0c02fb55956c7d316"  # Replace with your desired AMI
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  tags = {
    Name = "prod-web-instance"
    owners      = "aws"
    environment = "prod"
  }
}
