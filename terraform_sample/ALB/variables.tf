variable "subnets"{
type = "list"
}
variable "sg_lb" {} 
variable "vpc_id" {} 
variable "instances" {
type = "list"

}
variable "bucketname" {}
variable "instance_count" {}