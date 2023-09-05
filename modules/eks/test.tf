resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::834635717119:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/6D9DD03061886C7D5818954E28E552D4"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.us-east-1.amazonaws.com/id/6D9DD03061886C7D5818954E28E552D4:aud" : "sts.amazonaws.com",
            "oidc.eks.us-east-1.amazonaws.com/id/6D9DD03061886C7D5818954E28E552D4:sub" : "system:serviceaccount:default:test"
          }
        }
      }
    ]
  })

  tags = {
    tag-key = "service-account-role"
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
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test-policy.arn
}