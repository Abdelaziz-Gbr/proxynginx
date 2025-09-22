provider "aws" {
  shared_config_files      = ["conf"]
  shared_credentials_files = ["creds"]
  profile                  = "default"
}

module "vpc" {
  source   = "./vpc"
  vpc_cidr = var.vpc_cidr
}
module "subnet" {
  count       = 4
  source      = "./subnet"
  vpc_id      = module.vpc.vpc_id
  subnet_cidr = var.public_subnet_cidr[count.index]
}

module "internet_gw" {
  source           = "./internetgw"
  vpc_id           = module.vpc.vpc_id
  internet_gw_name = var.internet_gw_name
}

module "public-rt" {
  source           = "./public-rt"
  vpc_id           = module.vpc.vpc_id
  route_table_name = "public-rt"
  internet_gw_id   = module.internet_gw.internet_gateway_id
}

module "route_table_association" {
  count          = 2
  source         = "./routetable_association"
  subnet_id      = module.subnet[count.index].subnet_id
  route_table_id = module.public-rt.route_table_id
}

module "public_sg" {
  source = "./public_sg"
  vpc_id = module.vpc.vpc_id
}

module "public_instance" {
  count               = 2
  source              = "./instance"
  instance_type       = var.instance_type
  subnet_id           = module.subnet[count.index].subnet_id
  key_name            = var.key_name
  associate_public_ip = true
  security_group_id   = module.public_sg.public_sg_id
}

module "nat_gateway" {
  source           = "./nat_gatway"
  public_subnet_id = module.subnet[0].subnet_id
}

module "private_rt" {
  source           = "./private-rt"
  vpc_id           = module.vpc.vpc_id
  route_table_name = "private-rt"
  nat_gateway_id   = module.nat_gateway.nat_gateway_id
}

module "private_route_table_association" {
  count          = 2
  source         = "./routetable_association"
  subnet_id      = module.subnet[count.index + 2].subnet_id
  route_table_id = module.private_rt.route_table_id
}
module "private_sg" {
  source   = "./private_sg"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "private_instance" {
  count               = 2
  source              = "./instance"
  instance_type       = var.instance_type
  subnet_id           = module.subnet[count.index + 2].subnet_id
  key_name            = var.key_name
  associate_public_ip = false
  security_group_id   = module.private_sg.private_sg_id
}