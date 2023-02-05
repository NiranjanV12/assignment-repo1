data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}



module "mod_640_sg_1" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "640-sg-1"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${chomp(data.http.myip.body)}/32"
    }

  ]

egress_rules = [ "all-all"]


}



module "mod_640_sg_2" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "640-sg-2"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }

  ]

egress_rules = [ "all-all"]

}


module "mod_640_sg_3" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "640-sg-3"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }


  ]


egress_rules = [ "all-all"]

}
