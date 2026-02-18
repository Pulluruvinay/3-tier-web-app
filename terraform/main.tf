provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_user         = var.db_user
  db_password     = var.db_password
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ecs" {
  source           = "./modules/ecs"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  ecr_image        = var.ecr_image
  target_group_arn = module.alb.target_group_arn
  db_host          = module.rds.db_endpoint
  db_user          = var.db_user
  db_password      = var.db_password
}
