module "mod_640_inst_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "640-bastion"

  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  key_name               = "task1pem"
  monitoring             = true
  vpc_security_group_ids = [module.mod_640_sg_1.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "newtag"
}
}

module "mod_640_inst_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "640-jenkins"

  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  key_name               = "task1pem"
  monitoring             = true
  vpc_security_group_ids = [module.mod_640_sg_2.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "newtag"
}
}

module "mod_640_inst_3" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "640-app1"

  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  key_name               = "task1pem"
  monitoring             = true
  vpc_security_group_ids = [module.mod_640_sg_2.security_group_id]
  subnet_id              = module.vpc.private_subnets[1]

  tags = {
    Terraform = "True"
    Environment = "dev"
    newtag = "newtag"
}
}
