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

# Instance
resource "aws_instance" "webapp-dev" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  key_name = "demo-key"

    user_data = <<-EOF
    #!/bin/bash -xe
    sudo su
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    systemctl enable docker
    usermod -a -G docker ec2-user
    EOF

   tags = {
    Name = "Todo-App-Dev"
  }
}