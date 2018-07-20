provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

// terraform {
//   backend "s3" {
//     bucket = "la-terraform-course-state"
//     key = "terraform/terraform.tfstate"
//     region = "us-west-2"
//   }
// }

# Deploy Storage Resource
module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

# Deploy Networking Resources

module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  accessip     = "${var.accessip}"
}

# Deploy Compute Resources

module "compute" {
  source          = "./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  subnets         = "${module.networking.public_subnets}"
  security_group  = "${module.networking.public_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"
}

module "LB" {
  source          = "./ALB"
  vpc_id   = "${module.networking.vpc_id}"
  subnets         = "${module.networking.public_subnets}"
  sg_lb  = "${module.networking.public_sg}"
  instances = "${module.compute.servers_id}"
  bucketname = "${module.storage.bucketname}"
  instance_count = "${var.instance_count}"
}
