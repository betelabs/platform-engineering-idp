output 'cluster_endpoint'   { value = module.eks.cluster_endpoint }
output 'cluster_name'       { value = module.eks.cluster_name }
output 'oidc_provider_arn'  { value = module.eks.oidc_provider_arn }
output 'crossplane_role_arn'{ value = aws_iam_role.crossplane.arn }
