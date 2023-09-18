module "iam-role-aws-load-balancer-controller-sa" {
  source                   = "../modules/kubernetes-trust"
  eks-cluster-tfstate-path = "/mnt/c/Users/Praveen_Dwivedi/Desktop/Study/Terraform/Infrastructure/eks-cluster/terraform.tfstate"
  service-account = {
    namespace      = "kube-system"
    serviceaccount = "aws-load-balancer-controller"
  }
}

resource "aws_iam_policy" "load-balancer-controller-sa-policy" {
  policy = file("${path.module}/lb-controller-iam-policy.json")
}



resource "aws_iam_role_policy_attachment" "load-balancer-controller-sa-policy-attachement" {
  role       = module.iam-role-aws-load-balancer-controller-sa.sa-role-name
  policy_arn = aws_iam_policy.load-balancer-controller-sa-policy.arn
}

output "aws-load-balancer-controller-sa-role-arn" {
  value = module.iam-role-aws-load-balancer-controller-sa.sa-role-arn
}