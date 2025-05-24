variable "location" {
  description = "Azure reģions"
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "AKS resursu grupas nosaukums"
  default     = "aks-rg"
}

variable "cluster_name" {
  description = "AKS klastera nosaukums"
  default     = "aks-demo"
}

variable "subscription_id" {
  description = "AKS Subscription ID"
}