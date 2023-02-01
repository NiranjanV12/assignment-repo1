module "vote_service_sg_1" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service-1"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }

  ]

egress_rules = [ "all-all"]


}



module "vote_service_sg_2" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service-2"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id



egress_rules = [ "all-all"]

}