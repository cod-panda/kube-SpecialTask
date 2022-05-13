provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "springdemo" {
  name            = "springs"
  chart           = "./spring-kube"
  cleanup_on_fail = true
  timeout         = 60
  wait            = false
  lint            = true
}
