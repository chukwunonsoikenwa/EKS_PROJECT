terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      version = ">= 5.49.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "dev-nonso-tf-bucket"
    key    = "End-to-End-Kubernetes-DevSecOps-Tetris-Project/EKS-TF/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
