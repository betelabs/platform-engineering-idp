# Platform Engineering IDP — AWS EKS Cluster
# Provisions: VPC, EKS 1.29, node groups, IRSA for Crossplane, ALB controller

terraform {
  required_version = '>= 1.7'
  required_providers {
    aws        = { source = 'hashicorp/aws',        version = '~> 5.0' }
    kubernetes = { source = 'hashicorp/kubernetes',  version = '~> 2.0' }
    helm       = { source = 'hashicorp/helm',        version = '~> 2.0' }
  }
  backend 's3' {}
}

provider 'aws' { region = var.region }

module 'eks' {
  source  = 'terraform-aws-modules/eks/aws'
  version = '~> 20.0'

  cluster_name    = var.cluster_name
  cluster_version = '1.29'

  cluster_addons = {
    coredns            = { most_recent = true }
    kube-proxy         = { most_recent = true }
    vpc-cni            = { most_recent = true }
    aws-ebs-csi-driver = { most_recent = true }
    aws-load-balancer-controller = { most_recent = true }
  }

  eks_managed_node_groups = {
    platform = {
      instance_types = ['m5.large']
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      labels = {
        role = 'platform'
      }
      taints = [{
        key    = 'platform'
        value  = 'true'
        effect = 'NO_SCHEDULE'
      }]
    }
    workloads = {
      instance_types = ['m5.xlarge']
      min_size       = 2
      max_size       = 20
      desired_size   = 3
      labels = {
        role = 'workloads'
      }
    }
  }

  # IRSA for Crossplane AWS Provider
  enable_irsa = true

  tags = local.tags
}

# IRSA for Crossplane — allows Crossplane to provision AWS resources
resource 'aws_iam_role' 'crossplane' {
  name = '${var.cluster_name}-crossplane'
  assume_role_policy = jsonencode({
    Version = '2012-10-17'
    Statement = [{
      Effect    = 'Allow'
      Principal = { Federated = module.eks.oidc_provider_arn }
      Action    = 'sts:AssumeRoleWithWebIdentity'
      Condition = {
        StringEquals = {
          '${module.eks.oidc_provider}:sub' = 'system:serviceaccount:crossplane-system:crossplane'
        }
      }
    }]
  })
}

resource 'aws_iam_role_policy_attachment' 'crossplane' {
  role       = aws_iam_role.crossplane.name
  policy_arn = 'arn:aws:iam::aws:policy/AdministratorAccess'
  # scope down per your security requirements
}

locals {
  tags = {
    cluster    = var.cluster_name
    managed_by = 'terraform'
    owner      = 'platform-engineering'
  }
}
