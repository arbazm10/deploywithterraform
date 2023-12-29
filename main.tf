provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
  features {}
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "hello_world_namespace" {
  metadata {
    labels = {
      app = "hello-world-example"
    }
    name = "hello-world-namespace"
  }
}

resource "kubernetes_deployment" "hello_world_deployment" {
  metadata {
    name = "kubernetes-example-deployment"
    namespace = kubernetes_namespace.hello_world_namespace.metadata.0.name
    labels = {
      app = "hello-world-example"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "hello-world-example"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-world-example"
        }
      }
      spec {
        container {
          image = "myregistryterra.azurecr.io/nginx-acr:latest"
          name  = "hello-world"
        }
      }
    }
  }
}
