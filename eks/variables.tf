variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  default     = "eks-demo"
}

variable "node_instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}