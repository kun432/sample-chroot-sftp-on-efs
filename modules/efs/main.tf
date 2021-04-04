variable "stage" {}
variable "vpc_id" {}
variable "sg_id" {}
variable "private_subnet_id_c" {}
variable "private_subnet_id_d" {}

resource "aws_kms_key" "efs_cmk" {
  description = "efs-cmk"
  enable_key_rotation = true
  is_enabled = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "efs_cmk_alias" {
  name = "alias/${var.stage}-efs-kms-alias"
  target_key_id = aws_kms_key.efs_cmk.key_id
}

resource "aws_efs_file_system" "efs_fs" {
  creation_token = "efs_fs"
  encrypted = true
  kms_key_id = aws_kms_key.efs_cmk.arn

  tags = {
    Name = "${var.stage}-efs-fs"
  }
}

resource "aws_efs_access_point" "efs-ap" {
  file_system_id = aws_efs_file_system.efs_fs.id
}

resource "aws_efs_mount_target" "efs_fs_tgt_c" {
  file_system_id = aws_efs_file_system.efs_fs.id
  subnet_id = var.private_subnet_id_c
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "efs_fs_tgt_d" {
  file_system_id = aws_efs_file_system.efs_fs.id
  subnet_id = var.private_subnet_id_d
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  name = "${var.stage}-efs-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stage}-efs-sg"
  }
}

resource "aws_security_group_rule" "efs_sg_rule_allow_nfs_from_app_prv" {
  type                      = "ingress"
  from_port                 = 2049
  to_port                   = 2049
  protocol                  = "tcp"
  security_group_id         = aws_security_group.efs_sg.id
  source_security_group_id  = var.sg_id
}