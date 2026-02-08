#--------------------------------
# terraform
#--------------------------------
terraform {
  # terraform 本体のバージョン
  required_version = ">=1.14.4, <2.0.0"

  # インフラプロバイダのバージョン(AWS)
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
  }

  # リモートバックエンドの指定
  backend "s3" {
    bucket       = "ecs-practice-remote-backend-dev"
    key          = "dev/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
    encrypt      = true
    profile      = "ecs-practice"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "ecs-practice"

  # デフォルトタグ
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
    }
  }
}