# terraform.tf

terraform {
    required_version = ">= 1.5.7"

    required_providers {
        linode = {
            source = "linode/linode"
            version = ">= 2.9.3"
        }

        random = {
            source = "hashicorp/random"
            version = ">=3.1.0"
        }

        cloudinit = {
            source = "hashicorp/cloudinit"
            version = ">=2.3.3"
        }
    }
}