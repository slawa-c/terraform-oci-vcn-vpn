terraform {
  required_version = ">= 1.0.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
    oci = {
      source  = "hashicorp/oci"
      version = ">= 4.57.0"
    }
  }
}
