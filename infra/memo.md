# Terraform

## provider　ブロックの書き方
``` bash
# 注意点として、このブロック内は一切の変数が使用できない
# 変数ファイルよりも先にこちらが読み込まれるため

terraform {
  # terraform 本体のバージョン
  # バージョンの確認方法は、terraform --version
  required_version = ">= 1.14.4, < 2.0.0"

  # インフラプロバイダのバージョン(AWS)
  # バージョンの確認方法は、terraform レジストリから
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
    use_lockfile = true # 排他制御用のDynamoDBの作成が不要になった
    encrypt      = true
  }
}
```

## リモートバックエンドの作成方法
手順として確立しておく
ローカルでS3, DynameDBを作成する
作成したものを、バックエンドに切り替える

## ECSに関するメモ
ECSが必要とする外部リソース
```
IAM Policy           : Secret Manager へアクセス
IAM Role             : ECSタスクの実行
CLoudwatch Log Group : ECSのログ出力
```