resource "aws_iam_user" "eks-admin-user" {
  name = "eks-admin"


  tags = {
    Name = "eks-admin"
  }
}


resource "aws_iam_access_key" "eks-admin-user-access-key" {
  user = aws_iam_user.eks-admin-user.name

}

resource "aws_iam_policy" "eks-admin-policy" {
  name        = "eks-admin-policy"
  description = "My eks-admin policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "eks-admin-policy-attachment" {
  name       = "eks-admin-policy-attachment"
  policy_arn = aws_iam_policy.eks-admin-policy.arn
  users      = [aws_iam_user.eks-admin-user.name]
}

output "eks-admin-user-access-key-id" {
  value = aws_iam_access_key.eks-admin-user-access-key.id
}

output "eks-admin-user-secret-access-key" {
  value     = aws_iam_access_key.eks-admin-user-access-key.secret
  sensitive = true
}