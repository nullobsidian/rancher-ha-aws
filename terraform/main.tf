provider "aws" {}

provider "template" {}

terraform {
  backend "s3" {}
}

locals {
  tags = {
    "ClusterID"  = format("%s", var.cluster_id)
    "Environment" = format("%s", var.environment)
    "Terraform"   = "true"
  }
  owned  = {
    join("", ["kubernetes.io/cluster/", var.cluster_id]) = "owned"
  }
  shared  = {
    join("", ["kubernetes.io/cluster/", var.cluster_id]) = "shared"
  }
  cluster_name = join("", [ "rancher-", var.environment, "-", var.cluster_id])
}

data "aws_ami" "default" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Rancher Nodes - User Data
data "template_file" "init" {
  template = file("data/bootstrap.sh")

  vars = {
    docker_version = "19.03"
  }
}

// Rancher Node Pool
resource "aws_instance" "default" {
  depends_on    = [module.vpc]
  count         = var.node_count

  ami           = data.aws_ami.default.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  vpc_security_group_ids = flatten([aws_security_group.instances.id])

  iam_instance_profile   = aws_iam_instance_profile.master.id

  user_data = data.template_file.init.rendered

  root_block_device {
    volume_size = 250
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io1"
    volume_size = 50
    iops        = 1500
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_type = "io1"
    volume_size = 50
    iops        = 1500
  }

  tags = merge(
    {
      Name = format("%s", local.cluster_name)
    },
    local.tags,
    local.shared,
  )
}

// Bastion Host
resource "aws_instance" "bastion" {
  depends_on    = [module.vpc]
  ami           = data.aws_ami.default.id
  instance_type = "t3.small"
  key_name      = var.key_name

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = flatten([aws_security_group.instances.id])

  root_block_device {
    volume_size = 30
  }

  tags = merge(
    {
      Name = join("", [ "bastion-rancher-", var.cluster_id])
    },
    local.tags,
    local.shared,
  )
}
