module "vpc" {
  source = "../../modules/network/vpc"

  # tags
  project     = var.project
  environment = var.environment

  # network
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
}