// AWS Cloud Provider
// Names
locals {
  master       = join("-", ["rancher-master", var.cluster_id])
  worker       = join("-", ["rancher-worker", var.cluster_id])
  controlplane = join("-", ["rancher-controlplane", var.cluster_id])
  etcd         = join("-", ["rancher-etcd", var.cluster_id])
  etcd_backup  = join("-", ["rancher-etcd_backup", var.cluster_id])
  cloud_creds  = join("-", ["rancher-cloud_creds", var.cluster_id])
}

//IAM Profiles
resource "aws_iam_instance_profile" "master" {
  name = local.master
  role = aws_iam_role.master.name
}

resource "aws_iam_instance_profile" "worker" {
  name = local.worker
  role = aws_iam_role.worker.name
}

resource "aws_iam_instance_profile" "rancher_template_master" {
  name = "rancher_template_master"
  role = aws_iam_role.rancher_template_master.name
}

resource "aws_iam_instance_profile" "rancher_template_worker" {
  name = "rancher_template_worker"
  role = aws_iam_role.rancher_template_worker.name
}

// IAM Roles
resource "aws_iam_role" "master" {
  name               = local.master
  assume_role_policy = jsonencode(local.role_master)
}

resource "aws_iam_role" "worker" {
  name               = local.worker 
  assume_role_policy = jsonencode(local.role_worker)
}

resource "aws_iam_role" "rancher_template_master" {
  name               = "rancher_template_master"
  assume_role_policy = jsonencode(local.role_master)
}

resource "aws_iam_role" "rancher_template_worker" {
  name               = "rancher_template_worker"
  assume_role_policy = jsonencode(local.role_worker)
}

// IAM Policy
resource "aws_iam_policy" "controlplane" {
  name   = local.controlplane
  path   = "/"
  policy = jsonencode(local.policy_controlplane)
}

resource "aws_iam_policy" "etcd" {
  name   = local.etcd
  path   = "/"
  policy = jsonencode(local.policy_etcd)
}

resource "aws_iam_policy" "worker" {
  name   = local.worker
  path   = "/"
  policy = jsonencode(local.policy_worker)
}

resource "aws_iam_policy" "etcd_backup" {
  name   = local.etcd_backup
  path   = "/"
  policy = data.template_file.etcd_backup.rendered
}

data "template_file" "etcd_backup" {
  template = file("${path.module}/data/etcd_backup.json")
  vars = {
    s3_backup = aws_s3_bucket.backup.id
  }
}

// IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "controlplane" {
  role       = aws_iam_role.master.name
  policy_arn = aws_iam_policy.controlplane.arn
}

resource "aws_iam_role_policy_attachment" "etcd" {
  role       = aws_iam_role.master.name
  policy_arn = aws_iam_policy.etcd.arn
}

resource "aws_iam_role_policy_attachment" "worker" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.worker.arn
}

resource "aws_iam_role_policy_attachment" "etcd_backup" {
  role       = aws_iam_role.master.name
  policy_arn = aws_iam_policy.etcd_backup.arn
}

resource "aws_iam_role_policy_attachment" "controlplane_template" {
  role       = aws_iam_role.master.name
  policy_arn = aws_iam_policy.controlplane.arn
}

resource "aws_iam_role_policy_attachment" "etcd_template" {
  role       = aws_iam_role.master.name
  policy_arn = aws_iam_policy.etcd.arn
}

// Locals
locals {
  # IAM Role
  role_master = {
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow"
        "Principal" = {
          "Service" = [
            "ec2.amazonaws.com",
          ]
        }
        "Action" = "sts:AssumeRole"
      }
    ]
  }

  role_worker = {
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow"
        "Principal" = {
          "Service" = [
            "ec2.amazonaws.com",
          ]
        }
        "Action" = "sts:AssumeRole"
      }
    ]
  }

  # IAM Policy
  policy_controlplane = {
    "Version": "2012-10-17",
    "Statement": [
      {   
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "iam:CreateServiceLinkedRole",
          "kms:DescribeKey"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }

  policy_etcd = {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }

  policy_worker = {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }
}

// AWS Cloud Credentials User to Provision EC2 in Rancher
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_user" "cloud_creds" {
  name = join("-", ["rancher-admin", var.cluster_id])
  path = "/"

  tags = merge(
    local.tags,
    local.shared,
  )
}

resource "aws_iam_access_key" "cloud_creds" {
  user = aws_iam_user.cloud_creds.name
}

resource "aws_iam_user_policy" "cloud_creds" {
  name   = local.cloud_creds
  user   = aws_iam_user.cloud_creds.name
  policy = data.template_file.cloud_creds.rendered
}

data "template_file" "cloud_creds" {
  template = file("${path.module}/data/cloud_creds.json")
  vars = {
    region = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  }
}
