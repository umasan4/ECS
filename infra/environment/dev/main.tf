#--------------------------------
# network 
#--------------------------------
### vpc ###
module "vpc" {
  source           = "../../modules/network/vpc"
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  name             = "${var.project}-${var.environment}-vpc"
}

### igw ###
module "igw" {
  source = "../../modules/network/igw"
  vpc_id = module.vpc.vpc_id
  name   = "${var.project}-${var.environment}-igw"
}

### subnet ###
module "public_subnet" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  subnets        = var.public_subnets
  name           = "${var.project}-${var.environment}"
  route_table_id = module.public_route_table.ids
}

module "private_subnet" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  subnets        = var.private_subnets
  name           = "${var.project}-${var.environment}"
  route_table_id = module.private_route_table.ids
}

### route_table ###
module "public_route_table" {
  source = "../../modules/network/route_table"
  vpc_id = module.vpc.vpc_id
  name   = "${var.project}-${var.environment}-public-rt"

  routes = {
    "igw" = {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.igw.igw_id
    }
  }
}

module "private_route_table" {
  source = "../../modules/network/route_table"
  vpc_id = module.vpc.vpc_id
  name   = "${var.project}-${var.environment}-private-rt"
  routes = {}
}