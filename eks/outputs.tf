output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.region
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider created by EKS module"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "OIDC URL (without ARN prefix)"
  value       = module.eks.oidc_provider
}

output "cluster_autoscaler_irsa_iam_role_arn" {
  description = "ARN of the IAM role for Cluster Autoscaler (IRSA)"
  value       = module.cluster_autoscaler_irsa.iam_role_arn
}