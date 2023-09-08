resource "aws_iam_openid_connect_provider" "default" {
  url = aws_eks_cluster.my-cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}


output "oidc-arn" {
  value = aws_iam_openid_connect_provider.default.arn
}

output "oidc-url" {
  value = aws_iam_openid_connect_provider.default.url
}