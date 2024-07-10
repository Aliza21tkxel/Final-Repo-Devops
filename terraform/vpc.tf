# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = var.name
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = element(var.public_subnets, 0)
  availability_zone        = var.azs[0]
  map_public_ip_on_launch  = true

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

# Route Table Association for public subnets
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
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
    Name        = "${var.environment}-web-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "Terraform-ec2" {
  ami           = "ami-0c02fb55956c7d316"  # Replace with your desired AMI
  instance_type = "t3.micro"
  key_name      = "my-terraform-key"     # Name of the key pair created in AWS 
  tags = {
    Name = "${var.environment}-web-instance"
  }
  provisioner "local-exec" {
    command = <<EOT
      echo "[Terraform-ec2]" > inventory
      echo "${aws_instance.Terraform-ec2.public_ip} ansible_user=ubuntu" >> inventory
      ansible-playbook -i inventory ../ansible/playbooks/docker-setup.yml
    EOT
  }


}



