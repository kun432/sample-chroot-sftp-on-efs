module "provider" {
  source = "../../modules/provider"
}

module "vpc" {
  source = "../../modules/vpc"
  stage  = var.stage
  vpc_cidr  = var.vpc_cidr
}

module "security-groups" {
  source = "../../modules/security-groups"
  stage  = var.stage
  vpc_id = module.vpc.vpc_id
  vpc_cidr  = var.vpc_cidr
}

module "ssm" {
  source = "../../modules/ssm"
  vpc_id = module.vpc.vpc_id
  sg_id = module.security-groups.sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "efs" {
  source = "../../modules/efs"
  stage  = var.stage
  vpc_id = module.vpc.vpc_id
  sg_id = module.security-groups.sg_id
  private_subnet_id_c = module.vpc.private_subnet_id_c
  private_subnet_id_d = module.vpc.private_subnet_id_d
}