module "network" {
  source = "./modules/network"
}

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.network.vpc_id
}

module "keypair" {
  source = "./modules/keypair"
  public_key_path = var.public_key_path
  key_name = var.key_name
}

module "monitoring" {
  source = "./modules/compute"
  name_prefix = "monitoring"
  instance_count = var.monitoring_count
  instance_type = var.instance_type
  key_name = module.keypair.key_name
  subnet_id = module.network.public_subnet_id
  security_group_ids = [module.sg.sg_id]
}

module "target" {
  source = "./modules/compute"
  name_prefix = "target"
  instance_count = var.target_count
  instance_type = var.instance_type
  key_name = module.keypair.key_name
  subnet_id = module.network.public_subnet_id
  security_group_ids = [module.sg.sg_id]
}
