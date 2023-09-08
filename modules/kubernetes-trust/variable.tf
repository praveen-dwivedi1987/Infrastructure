variable "service-account" {
  type = map(string)
  default = {
    namespace      = "default"
    serviceaccount = "sa1"
  }

}

variable "eks-cluster-tfstate-path" {
  default = "../../project-a/terraform.tfstate"
}