#--------------------------------
# vars
#--------------------------------
locals {
  project     = "ecs-practice"
  environment = "boot"
}

#--------------------------------
# terraform
#--------------------------------
terraform {
  # terraform 本体のバージョン
  required_version = ">= 1.14.4, < 2.0.0"

  # インフラプロバイダのバージョン(AWS)
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
  }

  # リモートバックエンドの指定
  backend "s3" {
    bucket       = "ecs-practice-remote-backend-boot"
    key          = "boot/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
    encrypt      = true
  }
}

# AWS プロバイダの設定
provider "aws" {
  region  = "ap-northeast-1"
  profile = "ecs-practice"

  # デフォルトタグ(全リソースに付与)
  default_tags {
    tags = {
      Project     = local.project
      Environment = local.environment
    }
  }
}