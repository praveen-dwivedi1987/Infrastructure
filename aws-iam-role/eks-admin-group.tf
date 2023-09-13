data "aws_caller_identity" "current" {
  
}


resource "aws_iam_role" "eks-admin-group-role" {
  name = "eks-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"}
      },
    ]
  })
}

resource "aws_iam_policy" "eks-admin-group-role-policy" {
  name        = "eks-admin-group-role-policy"
  description = "eks admin user policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "eks:*"
        ]
        "Resource" : ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-admin-role-policy-attachment" {
  policy_arn = aws_iam_policy.eks-admin-group-role-policy.arn
  role      = aws_iam_role.eks-admin-group-role.name
}

resource "aws_iam_group" "eks-admin-group" {
  name = "eks-admin-group"
}

resource "aws_iam_policy" "eks-admin-group-policy" {
  name = "eks-admin-group-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid      = "AllowAssumeOrganizationAccountRole"
        Resource = "${aws_iam_role.eks-admin-group-role.arn}"
      },
    ]
  })
}
resource "aws_iam_group_policy_attachment" "eks-admin-group-policy-attachement" {
  group      = aws_iam_group.eks-admin-group.name
  policy_arn = aws_iam_policy.eks-admin-group-policy.arn
}