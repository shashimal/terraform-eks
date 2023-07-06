resource "kubernetes_service_account" "action" {
  metadata {
    name      = "service-account-github-action"
    namespace = local.service_account_namespace
  }
}

resource "kubernetes_secret" "action" {
  metadata {
    name      = "service-account-github-action-token"
    namespace = local.service_account_namespace
    annotations = {
      "kubernetes.io/service-account.name" = "service-account-github-action"
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_role" "action" {
  metadata {
    name      = "role-github-action"
    namespace = local.service_account_namespace
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "services", "serviceaccounts"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create", "get"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["secrets-store.csi.x-k8s.io"]
    resources  = ["secretproviderclasses"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
}

resource "kubernetes_role_binding" "action" {
  metadata {
    name      = "role-binding-github-action"
    namespace = local.service_account_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.action.metadata[0].name
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "service-account-github-action"
    namespace = local.service_account_namespace
  }
}
