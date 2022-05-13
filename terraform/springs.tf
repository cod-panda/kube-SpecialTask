terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


resource "kubernetes_namespace" "springdemo" {
  metadata {
    name = "springs"
  }
}

resource "kubernetes_deployment" "springdemo" {
  metadata {
    name      = "springs"
    namespace = kubernetes_namespace.springdemo.metadata.0.name
  }
  spec {
    replicas                  = 2
    progress_deadline_seconds = 60
    selector {
      match_labels = {
        app = "springdemo"
      }
    }
    template {
      metadata {
        labels = {
          app = "springdemo"
        }
      }
      spec {
        container {
          image             = "docker.io/cod4panda/springboot_app:0.1.2"
          name              = "springboot"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            failure_threshold = 3
            http_get {
              path = "/hello"
              port = 8080
            }
          }
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "springdemo" {
  metadata {
    name      = "springdemo"
    namespace = kubernetes_namespace.springdemo.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.springdemo.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      node_port   = 31162
      port        = 8080
      target_port = 8080
    }
  }
}
