data "terraform_remote_state" "eks-cluster" {
  backend = "local"

  config = {
    path = var.eks-cluster-tfstate-path
  }
}

data "aws_iam_openid_connect_provider" "eks-oidc" {
  #url = data.terraform_remote_state.eks-cluster.outputs.oidc-url
  arn = data.terraform_remote_state.eks-cluster.outputs.oidc-arn
}




locals {
  oidc-provider = data.terraform_remote_state.eks-cluster.outputs.oidc-url
}

resource "aws_iam_role" "test_role" {
  name = "${var.service-account.serviceaccount}-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : data.aws_iam_openid_connect_provider.eks-oidc.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${local.oidc-provider}:aud" : "sts.amazonaws.com",
            "${local.oidc-provider}:sub" : "system:serviceaccount:${var.service-account.namespace}:${var.service-account.serviceaccount}"
          }
        }
      }
    ]
  })

  tags = {
    tag-key = "service-account-role"
  }
}

output "sa-role-name" {
  value = aws_iam_role.test_role.name
}


output "sa-role-arn" {
  value = aws_iam_role.test_role.arn
}