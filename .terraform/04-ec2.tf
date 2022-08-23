# Key Pair
resource "aws_key_pair" "deployer" {
  key_name = "demo-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9656cFKr1EWommDyDT9qGfCAaqrr/YpcEwhG9f15HtxX16bsHDc/jOAmL1/KSclXcUQxs8tPGkTSmYP9K9eCjjllbQ8QMS4bicKs7Rpn43Ep2r7ccno7yMDbdLNyLDBfXBbSQU4+jA0CfYIjh18PH/jypLsGPMWzOlpL47SyKnz1zTqqc9BQ+ZXVC32pqYi9ZUijRBo58Q6wiCZiaaeUxoK6WrLQKs1EG+3mB/1OQ/PohGGCmUIxA35Zk74mRb7PNNdjDnT7cFHSa+7xPnPtwjgu5rNV7vdZtrVd32+sVdfv3cEWRLS6oBQzTaNRDTxKW1Oi2Ha++VXv2P9a7FCWF nina.rojanek@wro1-ldl-p91652"
}

# Instance EC2
resource "aws_instance" "webapp" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

    user_data = <<-EOF
    #!/bin/bash -xe
    sudo su
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    systemctl enable docker
    usermod -a -G docker ec2-user
    docker pull mongo
    docker run -it --rm -d --name mongo -p 27017:27017 mongo
    docker login -unina.rojanek@globallogic.com -p Nin@2022 ninagl.jfrog.io
    docker run -it --rm -d --name webapp -p 8080:8080 --net host ninagl.jfrog.io/project-docker-local/webapp:latest
    EOF

   tags = {
    Name = "Todo-App"
  }
}

resource "aws_instance" "jenkins" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

  # lifecycle {
  #       prevent_destroy = true
  #   }

  user_data = <<-EOF
    #!/bin/bash -xe
    sudo yum update –y
    sudo yum install git -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum upgrade -y
    sudo amazon-linux-extras install java-openjdk11 -y
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins
    git clone https://github.com/nkaGL/da-final-project.git
    sudo ./da-final-project/scripts/jenkins_init.sh
  EOF

   tags = {
    Name = "Jenkins"
  }
}

# Security Group
resource "aws_security_group" "projectdev-sg" {
  name        = "projectdev-SG"
  description = "Allows HTTP, SSH ingress and all egress"
  vpc_id      = aws_vpc.projectdev.id
}

resource "aws_security_group_rule" "projectdev-sg-webapp" {
  type              = "ingress"
  security_group_id = aws_security_group.projectdev-sg.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows TCP inbound traffic"
}
resource "aws_security_group_rule" "projectdev-sg-db" {
  type              = "ingress"
  security_group_id = aws_security_group.projectdev-sg.id
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows Mongodb inbound traffic"
}
resource "aws_security_group_rule" "projectdev-SG-all-egress" {
  type              = "egress"
  security_group_id = aws_security_group.projectdev-sg.id
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows all outbound traffic"
}

