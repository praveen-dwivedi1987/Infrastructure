module "iam-role-my-sa-test" {
  source                   = "../modules/kubernetes-trust"
  eks-cluster-tfstate-path = "/mnt/c/Users/Praveen_Dwivedi/Desktop/Study/Terraform/Infrastructure/eks-cluster/terraform.tfstate"
  service-account = {
    namespace      = "default"
    serviceaccount = "my-sa-test"
  }
}

resource "aws_iam_policy" "test-policy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = module.iam-role-my-sa-test.sa-role-name
  policy_arn = aws_iam_policy.test-policy.arn
}

output "sa-role-arn" {
  value = module.iam-role-my-sa-test.sa-role-arn
}