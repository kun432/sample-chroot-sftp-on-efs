variable "stage" {}
variable "vpc_id" {}
variable "vpc_cidr" {}

resource "aws_security_group" "public" {
  name = "${var.stage}-public-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stage}-public-sg"
  }
}

resource "aws_security_group_rule" "allow_all_from_same_vpc" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  security_group_id         = aws_security_group.public.id
  cidr_blocks               = [var.vpc_cidr]
}

resource "aws_security_group" "private" {
  name = "${var.stage}-private-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stage}-private-sg"
  }
}

resource "aws_security_group_rule" "allow_all_from_public_sg" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  security_group_id         = aws_security_group.private.id
  source_security_group_id  = aws_security_group.public.id 
}

resource "aws_security_group_rule" "allow_all_from_same_sg" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  security_group_id         = aws_security_group.private.id
  source_security_group_id  = aws_security_group.private.id
}

output sg_id {
  value = aws_security_group.private.id
}