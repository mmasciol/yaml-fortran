# ./main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "masciola-dev"
    workspaces {
      name = "gh-actions"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "website" {
  source = "./aws-resources/"
  domain_name = var.domain_name
}
