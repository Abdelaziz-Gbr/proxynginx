terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-300301"
    key            = "lock"
    use_lockfile   = true
    region         = "us-east-1"
    encrypt        = true
  }
}

module "vpc" {
  source   = "./vpc"
  vpc_cidr = var.vpc_cidr
}
module "subnet" {
  count             = 4
  source            = "./subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr       = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
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

module "proxy_alb" {
  source                      = "./alb"
  name                        = "proxy-alb"
  internal                    = false
  security_group_id           = module.public_sg.public_sg_id
  subnet_ids                  = [module.subnet[0].subnet_id, module.subnet[1].subnet_id]
  target_group_name           = "proxy-tg"
  vpc_id                      = module.vpc.vpc_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  asg_name                    = "proxy-asg"
  max_size                    = 2
  min_size                    = 2
  desired_capacity            = 2
  user_data                   = templatefile("proxy-userdata", { private_alb_dns = module.service_alb.lb_dns_name })
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

module "service_alb" {
  source                      = "./alb"
  name                        = "service-alb"
  internal                    = true
  security_group_id           = module.private_sg.private_sg_id
  subnet_ids                  = [module.subnet[2].subnet_id, module.subnet[3].subnet_id]
  target_group_name           = "service-tg"
  vpc_id                      = module.vpc.vpc_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = false
  asg_name                    = "service-asg"
  max_size                    = 2
  min_size                    = 2
  desired_capacity            = 2
  user_data                   = file("nginx-userdata")
}

/* 


module "private_instance" {
  count               = 2
  source              = "./instance"
  instance_type       = var.instance_type
  subnet_id           = module.subnet[count.index + 2].subnet_id
  key_name            = var.key_name
  associate_public_ip = false
  security_group_id   = module.private_sg.private_sg_id
} */