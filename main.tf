locals {
  type                    = var.type
  vpc_id                  = var.vpc_id
  subnet_ids              = compact(var.subnet_ids)
  security_group_ids      = compact(var.security_group_ids)
  cpu                     = var.cpu
  memory                  = var.memory
  cluster_id              = var.cluster_id
  task_execute_role_arn   = var.task_execute_role_arn
  image_pull_secret_arn   = var.image_pull_secret_arn
  application_credentials = var.application_credentials
  image                   = var.image
}

module "ecs" {
  source             = "./modules/ecs"
  vpc_id             = local.vpc_id
  security_group_ids = local.security_group_ids
  subnet_ids         = local.subnet_ids
  count              = local.type == "ecs" ? 1 : 0

  cluster_id              = local.cluster_id
  task_execute_role_arn   = local.task_execute_role_arn
  image_pull_secret_arn   = local.image_pull_secret_arn
  application_credentials = local.application_credentials
  image                   = local.image
}

module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = local.vpc_id
  security_group_ids = var.security_group_ids
  subnet_ids         = local.subnet_ids
  count              = local.type == "ec2" ? 1 : 0
}