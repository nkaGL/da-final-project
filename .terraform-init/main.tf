terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

#S3 bucket for Terraform Backend
resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraformstate-ninagl2022"

      # lifecycle {
      #     prevent_destroy = true
      # }
    
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                  sse_algorithm = "AES256"
            }
        }
    }
}

# SSH Key Pair 
resource "aws_key_pair" "deployer" {
  key_name = "demo-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9656cFKr1EWommDyDT9qGfCAaqrr/YpcEwhG9f15HtxX16bsHDc/jOAmL1/KSclXcUQxs8tPGkTSmYP9K9eCjjllbQ8QMS4bicKs7Rpn43Ep2r7ccno7yMDbdLNyLDBfXBbSQU4+jA0CfYIjh18PH/jypLsGPMWzOlpL47SyKnz1zTqqc9BQ+ZXVC32pqYi9ZUijRBo58Q6wiCZiaaeUxoK6WrLQKs1EG+3mB/1OQ/PohGGCmUIxA35Zk74mRb7PNNdjDnT7cFHSa+7xPnPtwjgu5rNV7vdZtrVd32+sVdfv3cEWRLS6oBQzTaNRDTxKW1Oi2Ha++VXv2P9a7FCWF nina.rojanek@wro1-ldl-p91652"
}

# Jenkins instance
resource "aws_instance" "jenkins" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  security_groups = ["default"]

  # lifecycle {
  #       prevent_destroy = true
  #   }

  user_data = <<-EOF
    #!/bin/bash -xe
    sudo su
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    systemctl enable docker
    yum install git -y
    wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum upgrade -y
    amazon-linux-extras install java-openjdk11 -y
    yum install jenkins -y
    systemctl enable jenkins
    systemctl start jenkins
    systemctl status jenkins
  EOF

   tags = {
    Name = "Jenkins"
  }
}
output "jenkins_public_ip" {
  description = "Public IP address of the EC2 instance with WebApp on Dev"
  value       = aws_instance.jenkins.public_ip
}