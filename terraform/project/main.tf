module "vpc" {
    source = "./modules/vpc"
    project_name = var.project_name
}
module "loadbalancer" {
    source = "./modules/loadbalancer"
    vpc_id = module.vpc.vpc_id
    sn_pub01 = module.vpc.sn_pub01

}

module "backend" {
    source = "./modules/backend"
    vpc_id = module.vpc.vpc_id
 
}

module "database" {
    source = "./modules/database"
    vpc_id = module.vpc.vpc_id    
}

module "frontend" {
    source = "./modules/frontend"
    vpc_id = module.vpc.vpc_id
    sn_pub01 = module.vpc.sn_pub01
}
