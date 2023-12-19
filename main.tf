provider "azurerm" {
  subscription_id = "898734ae-50a5-4891-b151-0d0c58eaf0d6"
  client_id       = "3866a430-e151-47f0-b582-2f1e5c4264f7"
  client_secret   = "n4L8Q~LkOQoCbMoral-ufBbz-~9zaF_La-5A9bRP"
  tenant_id       = "945d465f-bcf2-485e-aefd-d714990419c0"
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
