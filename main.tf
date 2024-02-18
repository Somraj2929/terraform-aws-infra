terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-2"
}

resource "aws_vpc" "tfproject" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tfproject"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.tfproject.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet Terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.tfproject.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet Terraform"
  }
}

resource "aws_internet_gateway" "tfgateway" {
  vpc_id = aws_vpc.tfproject.id

  tags = {
    Name = "Internet Gateway Terraform"
  }
}

resource "aws_route_table" "publictf" {
  vpc_id = aws_vpc.tfproject.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tfgateway.id
  }

  tags = {
    Name = "route-table-terraform"
  }
}

resource "aws_route_table_association" "publictf" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.publictf.id
}

resource "aws_instance" "web_server_tf" {
  ami           = "ami-05fb0b8c1424f266b"
  instance_type = "t2.micro"
  key_name      = "tf-key"
  subnet_id     = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.ssh_access.id
  ]

  user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo "<html><body><h1>Welcome to Terraform AWS Project!!</h1><br><h3>Hey! You are genius. You done it.</h3><br><p>Note* - If bored with too many created resources. Just type "terraform destroy" and boom!!💣💣</p></body></html>" > /var/www/html/index.html
        sudo systemctl restart apache2
  EOF

  tags = {
    Name = "Terrform Project AWS"
  }
}

resource "aws_security_group" "ssh_access" {
  name_prefix = "ssh_access"
  vpc_id      = aws_vpc.tfproject.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.web_server_tf.id

  tags = {
    Name = "terraform-eip"
  }
}
