in this example terraform will provision an AWS load balancer (network) on port 80  that serve 2 EC2 instances with httpd.
the modules:
- ALB:  contain the definition of a network load balancer
- compute: definition of the EC2 instances with security group and templates
- storage: definition of an S3 buket that will be used by ALB to store access log
- networking: definition of VPC, IGW, public and private subnets and route table

to use update the terraform.tfvars  with the appropriate informations (keys, region..).


