// General Variables

variable "linux_admin_username" {
  type        = "string"
  description = "User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
}

variable "linux_admin_password" {
  type ="string"
  description = "The password for the Linux admin account."
}

// GCP Variables
variable "cluster_name" {
  type = "string"
  description = "Cluster name for the GCP Cluster."
}

variable "default_node_pool_name" {
  type = "string"
  description = "Name for default node pool of cluster."
}

// GCP Outputs
output "gcp_cluster_endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}

output "gcp_ssh_command" {
  value = "ssh ${var.linux_admin_username}@${google_container_cluster.primary.endpoint}"
}

output "gcp_cluster_name" {
  value = "${google_container_cluster.primary.name}"
}