variable "storage_access_key" {
  type = string
  default = "minio"
}

output "storage_access_key" {
  value = var.storage_access_key
}

resource "random_password" "storage" {
  length = 16
  special = true
  override_special = "_%@"
}

output "storage_password" {
  value = random_password.storage.result
  sensitive = true
}

resource "kubernetes_secret" "storage" {
  metadata {
    name = "storage"
  }

  data = {
    access_key = var.storage_access_key
    secret_key = random_password.storage.result
  }
}

resource "kubernetes_secret" "storage-access-key" {
  metadata {
    name = "storage-access-key"
    namespace = "openfaas-fn"
  }

  data = {
    storage-access-key = var.storage_access_key
  }
}

resource "kubernetes_secret" "storage-secret-key" {
  metadata {
    name = "storage-secret-key"
    namespace = "openfaas-fn"
  }

  data = {
    storage-secret-key = random_password.storage.result
  }
}