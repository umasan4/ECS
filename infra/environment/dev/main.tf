module "vpc" {
  source = "../../modules/network/vpc"

  # tags
  project     = local.project
  environment = local.environment

  # network
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
}