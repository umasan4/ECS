#--------------------------------
# terraform
#--------------------------------
terraform {
  required_version = ">=1.14.4, <2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "ecs-practice"
}