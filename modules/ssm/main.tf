variable "vpc_id" {}
variable "sg_id" {}
variable "private_subnet_ids" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.ap-northeast-1.s3"
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.sg_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.sg_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.sg_id]
  private_dns_enabled = true
}