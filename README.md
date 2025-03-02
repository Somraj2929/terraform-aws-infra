# Terraform Project - Building AWS Infrastructure with Ease using Infrastructure as Code (IaC) ☁️

Welcome🙏🫶

## Task

- Create a VPC (Virtual Private Cloud) with CIDR block 10.0.0.0/16
- Create a public subnet with CIDR block 10.0.1.0/24 in the above VPC.
- Create a private subnet with CIDR block 10.0.2.0/24 in the above VPC.
- Create an Internet Gateway (IGW) and attach it to the VPC.
- Create a route table for the public subnet and associate it with the public subnet. This route table should have a route to the Internet Gateway.
- Launch an EC2 instance in the public subnet with the following details:
- AMI: ami-05fb0b8c1424f266b (Latest Ubuntu Machine)
- Instance type: t2.micro
- Security group: Allow SSH access from anywhere
- User data: Use a shell script to install Apache/Nginx and host a simple website
- Create an Elastic IP and associate it with the EC2 instance.
- Open the website URL in a browser to verify that the website is hosted successfully.

Happy Terraforming:)
