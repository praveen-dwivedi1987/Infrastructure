
resource "aws_iam_role" "aws-power-user-group-role" {
  name = "aws-power-user-group-role"
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

resource "aws_iam_policy" "aws-power-user-group-role-policy" {
  name = "aws-power-user-group-role-policy"
  description = "power user policy for non admin users"
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"eks:*"
			],
			"Resource": [
				"*"
			]
		}
	]
})
}


resource "aws_iam_role_policy_attachment" "aws-power-user-group-role-policy-attachement" {
  policy_arn = aws_iam_policy.aws-power-user-group-role-policy.arn
  role = aws_iam_role.aws-power-user-group-role.name
}

resource "aws_iam_group" "power-user-group" {
  name = "power-user-group"
}

resource "aws_iam_policy" "power-user-group-policy" {
    name = "power-user-group-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid      = ""
        Resource = "${aws_iam_role.aws-power-user-group-role.arn}"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "power-user-group-policy-attachement" {
  group = aws_iam_group.power-user-group.name
  policy_arn = aws_iam_policy.power-user-group-policy.arn
}