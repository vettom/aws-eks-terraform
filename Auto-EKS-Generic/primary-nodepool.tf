
resource "kubernetes_manifest" "nodepool_primary_nodepool" {
#   manifest = {
#     "apiVersion" = "karpenter.sh/v1"
#     "kind"       = "NodePool"
#     "metadata" = {
#       "name" = "primary-nodepool"
#     }
#     "spec" = {
#       "template" = {
#         "spec" = {
#           "expireAfter" = "336h"
#           "nodeClassRef" = {
#             "group" = "eks.amazonaws.com"
#             "kind"  = "NodeClass"
#             "name"  = "default"
#           }
#           "requirements" = [
#             {
#               "key"      = "karpenter.sh/capacity-type"
#               "operator" = "In"
#               "values" = [
#                 "spot",
#                 "on-demand",
#               ]
#             },
#             {
#               "key"      = "eks.amazonaws.com/instance-category"
#               "operator" = "In"
#               "values" = [
#                 "c",
#                 "m",
#                 "r",
#               ]
#             },
#             {
#               "key"      = "eks.amazonaws.com/instance-generation"
#               "operator" = "Gt"
#               "values" = [
#                 "5",
#               ]
#             },
#             {
#               "key"      = "kubernetes.io/arch"
#               "operator" = "In"
#               "values" = [
#                 "amd64",
#               ]
#             },
#             {
#               "key"      = "kubernetes.io/os"
#               "operator" = "In"
#               "values" = [
#                 "linux",
#               ]
#             },
#           ]
#           "terminationGracePeriod" = "24h0m0s"
#         }
#       }
#       "weight" = 50
#     }
#   }

# }
