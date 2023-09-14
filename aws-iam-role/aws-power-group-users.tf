resource "aws_iam_user" "power-users" {
  name = "power-user-1"
}

resource "aws_iam_group_membership" "power-users-group-membership" {
  name = "power-users-group-membership"
  group = aws_iam_group.power-user-group.name
  users = [aws_iam_user.power-users.name]
}