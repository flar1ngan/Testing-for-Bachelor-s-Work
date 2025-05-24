variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-north1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-north1-b"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "gke-demo"
}

variable "credentials_file" {
  description = "Path to the service account JSON file"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account to attach to nodes"
  type        = string
}