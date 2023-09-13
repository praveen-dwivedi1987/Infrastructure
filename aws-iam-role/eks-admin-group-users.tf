resource "aws_iam_user" "eks-admin-group-users" {
  name = "eks-admin-1"
}

resource "aws_iam_group_membership" "eks-admin-group-users-membership" {
  name = "eks-admin-group-users-membership"
  users = [ aws_iam_user.eks-admin-group-users.name]
  group = aws_iam_group.eks-admin-group.name
}

resource "aws_iam_user_login_profile" "example" {
  user = aws_iam_user.eks-admin-group-users.name

}

output "password" {
  value = aws_iam_user_login_profile.example.encrypted_password
}