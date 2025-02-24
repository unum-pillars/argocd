resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "argocd"
  }

  provisioner "local-exec" {
    when    = create
    command = "kubectl create -k crd/"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -k crd/"
  }
}

data "kustomization_build" "resources" {
  path = "resources/"
}

resource "kustomization_resource" "resoures0" {
  for_each = data.kustomization_build.resources.ids_prio[0]

  manifest = data.kustomization_build.resources.manifests[each.value]

  depends_on = [kubernetes_namespace.namespace]
}

resource "kustomization_resource" "resoures1" {
  for_each = data.kustomization_build.resources.ids_prio[1]

  manifest = data.kustomization_build.resources.manifests[each.value]

  depends_on = [kustomization_resource.resoures0]
}

resource "kustomization_resource" "resoures2" {
  for_each = data.kustomization_build.resources.ids_prio[2]

  manifest = data.kustomization_build.resources.manifests[each.value]

  depends_on = [kustomization_resource.resoures1]
}
