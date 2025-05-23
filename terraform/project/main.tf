data "aws_vpc" "vpc_grupo_d" {
  id = "vpc-09706dbcf9fda1bc7"  # ID da sua VPC
}
module "vpc" {
    source = "./modules/vpc"
    project_name = var.project_name
}
module "loadbalancer" {
    source = "./modules/loadbalancer"
    vpc_id = data.aws_vpc.vpc_grupo_d.id
    sn_pub01 = module.vpc.sn_pub01

}

module "backend" {
    source = "./modules/backend"
    vpc_id = data.aws_vpc.vpc_grupo_d.id
   sn_pub01 = module.vpc.sn_pub01
 
}

module "database" {
    source = "./modules/database"
    vpc_id = data.aws_vpc.vpc_grupo_d.id
    sn_pub01 = module.vpc.sn_pub01
}

module "frontend" {
    source = "./modules/frontend"
    vpc_id = data.aws_vpc.vpc_grupo_d.id
    sn_pub01 = module.vpc.sn_pub01
}
