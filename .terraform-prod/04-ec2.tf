# Instance EC2
resource "aws_instance" "webapp-prod" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  key_name = "demo-key"
  security_groups = [aws_security_group.projectprod-sg.name]

    user_data = <<-EOF
    #!/bin/bash -xe
    sudo su
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    systemctl enable docker
    usermod -a -G docker ec2-user
    shutdown -r -f
    EOF

   tags = {
    Name = "Todo-App-Prod"
  }
}

# Security Group
resource "aws_security_group" "projectprod-sg" {
  name        = "projectprod-SG"
  description = "Allows HTTP, SSH ingress and all egress"
  vpc_id      = aws_vpc.projectprod.id
}

resource "aws_security_group_rule" "projectprod-sg-webapp" {
  type              = "ingress"
  security_group_id = aws_security_group.projectprod-sg.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows TCP inbound traffic"
}
resource "aws_security_group_rule" "projectprod-sg-db" {
  type              = "ingress"
  security_group_id = aws_security_group.projectprod-sg.id
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows Mongodb inbound traffic"
}
resource "aws_security_group_rule" "projectprod-SG-all-egress" {
  type              = "egress"
  security_group_id = aws_security_group.projectprod-sg.id
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allows all outbound traffic"
}

