module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "640-my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = true
  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "640-tag"
  }
}


output "vpc-cidrs" { value = [module.vpc.vpc_cidr_block] }
output "nat-ids" { value = [module.vpc.natgw_ids] }
output "private-subnets" { value = [module.vpc.private_subnets_cidr_blocks] }
output "public-subnets" { value = [module.vpc.public_subnets_cidr_blocks] }
