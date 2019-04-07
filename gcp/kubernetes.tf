resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  zone               = "europe-west3-a"

  network = "default"

  master_auth {
    username = "${var.linux_admin_username}"
    password = "${var.linux_admin_password}"
  }

  node_pool = [
    {
      name = "${var.default_node_pool_name}"
      node_count= 2
    }
  ]
}

resource "google_container_node_pool" "np" {
  name       = "${var.default_node_pool_name}"
  zone       = "europe-west3-a"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 2

  node_config {
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }

  # Delete the default node pool before spinning this one up
  depends_on = ["null_resource.default_cluster_deleter"]
}

resource "null_resource" "default_cluster_deleter" {
  depends_on = ["google_container_cluster.primary"]

  provisioner "local-exec" {
    command = <<EOF
      gcloud container node-pools \
        --project project-cloud-231013 \
        --zone europe-west3-a \
        --quiet \
        delete ${var.default_node_pool_name} \
        --cluster ${google_container_cluster.primary.name}
EOF
  }
}