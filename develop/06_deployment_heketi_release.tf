# resource "kubernetes_deployment" "fs-provisioner" {
#   depends_on = [ kubernetes_daemonset.fs-backend, kubernetes_deployment.fs-provisioner-bootstrap, kubernetes_config_map.fs-provisioner-config, kubernetes_secret.fs-config-secret ]
#   metadata {
#     name      = "fs-provisioner"
#     labels = {
#       app = "fs-provisioner"
#       resource = "deployment"
#     }
#   }
#   spec {
#     replicas = 1
#     template {
#       metadata {
#         labels = {
#           app = "fs-provisioner"
#           resource = "pod"
#           type = "release"
#         }
#       }
#       spec {
#         node_selector = {
#           "node-role.kubernetes.io/fs-provisioner" = ""
#         }
#         service_account_name = "fs-provisioner"
#         container {
#           image = "e8kor/heketi"
#           name  = "fs-provisioner"
#           port {
#             container_port = 8080
#           }
#           env {
#             name= "HEKETI_EXECUTOR"
#             value= "kubernetes"
#           }
#           env {
#             name= "HEKETI_DB_PATH"
#             value= "/var/lib/heketi/heketi.db"
#           }
#           env{
#             name= "HEKETI_FSTAB"
#             value= "/var/lib/heketi/fstab"
#           }
#           env {
#             name= "HEKETI_SNAPSHOT_LIMIT"
#             value= "14"
#           }
#           env {
#             name= "HEKETI_KUBE_GLUSTER_DAEMONSET"
#             value= "y"
#           }
#           volume_mount {
#             name= "db-secret"
#             mount_path= "/backupdb"
#           }
#           volume_mount {
#             name="db"
#             mount_path= "/var/lib/heketi"
#           }
#           volume_mount {
#             name="config"
#             mount_path="/etc/heketi"
#           }
#           readiness_probe {
#             http_get {
#               path = "/hello"
#               port = 8080
#             }
#             timeout_seconds = 3
#             initial_delay_seconds = 3
#           }
#           liveness_probe {
#             http_get {
#               path = "/hello"
#               port = 8080
#             }
#             timeout_seconds = 3
#             initial_delay_seconds = 3
#           }
#         }
#         volume {
#           name = "db"
#           glusterfs {
#             endpoints_name="heketi-storage-endpoints"
#             path="heketidbstorage"
#           }
#         }
#         volume {
#           name = "config"
#           config_map {
#             name = "fs-provisioner-config"
#           }
#         }
#         volume {
#           name = "db-secret"
#           secret{
#             secret_name="fs-db-secret"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "fs-provisioner" {
#   metadata {
#     name      = "fs-provisioner"
#     labels = {
#       app = "fs-provisioner"
#       resource = "service"
#     }
#   }
#   spec {
#     selector = {
#       app = "fs-provisioner"
#       resource = "pod"
#       type = "release"
#     }
    
#     port {
#       name = "fs-provisioner"
#       port    = 8080
#       target_port = 8080
#     }
#   }
# } 
