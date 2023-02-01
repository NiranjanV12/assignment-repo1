module "ec2_instance_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "bastion"

  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  key_name               = "task1pem"
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg_1.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "newtag"
}
}

module "ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "jenkins"

  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  key_name               = "task1pem"
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg_1.security_group_id,module.vote_service_sg_2.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "newtag"
}
}

module "ec2_instance_3" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "app1"

  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  key_name               = "task1pem"
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg_1.security_group_id]
  subnet_id              = module.vpc.private_subnets[1]

  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "newtag"
}

{