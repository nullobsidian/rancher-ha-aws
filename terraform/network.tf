data "aws_availability_zones" "default" {
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.cluster_name
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.default.names[0], data.aws_availability_zones.default.names[1], data.aws_availability_zones.default.names[2]]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_hostnames = true

  enable_nat_gateway = true
  one_nat_gateway_per_az = true
  single_nat_gateway = false

  tags = merge(
    local.tags,
    local.shared,
  )

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Security Groups
resource "aws_security_group" "instances" {
  name        = local.cluster_name
  description = "Managed by Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  tags = merge(
    local.tags,
    local.shared,
  )
}