terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
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
    replicas = 2
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
          image = "docker.io/cod4panda/springboot_app:demo"
          name  = "springboot"
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
