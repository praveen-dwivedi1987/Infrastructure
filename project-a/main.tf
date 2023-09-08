module "eks-cluster" {
  source = "../modules/eks"
  cluster_name = "my-cluster"
  node-groups = [
    {
      name          = "my-instance"
      desired_size  = 2
      max_size      = 3
      min_size      = 2
      instance_type = "t2.medium"
    },
    {
      name          = "my-instance2"
      desired_size  = 2
      max_size      = 3
      min_size      = 2
      instance_type = "t2.medium"
    }
  ]
}

output "oidc-url" {
  value = module.eks-cluster.oidc-url
}

output "oidc-arn" {
  value = module.eks-cluster.oidc-arn
}