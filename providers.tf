# =================================================================================================
# TERRAFORM SETTINGS
# =================================================================================================

terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
      version = ">= 1.4"
    }
  }
}