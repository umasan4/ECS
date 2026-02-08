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

タスク定義は、Terraform の jsonencode 関数 を使うのが良い (以下に利点)
```
1. 変数が使える: var.image_uri などの Terraform の値をそのまま埋め込める
2. 構文エラー防止 : カンマの忘れや括弧の対応など、JSON 特有のミスを Terraform が防いでくれる
3. 可読性 : Terraform (HCL) の記法で統一して書けるため、読みやすくなる
```

イメージの更新 (最新イメージを反映させたい場合)  
```bash
# 開発環境で最新イメージを反映させたい場合は、
# apply の後に以下の AWS CLI コマンドを実行して、強制的に新しいデプロイを行うのが一般的
aws ecs update-service --cluster <クラスター名> --service <サービス名> --force-new-deployment

# 本番環境のベストプラクティス: 
# 本番環境では latest を使わず、Git のコミットハッシュやビルド番号（例: :v1.0.1, :a1b2c3d）をタグとして使い、Terraform に変数として渡す運用が推奨される。これにより、Terraform が確実に変更を検知し、安全にロールバックも可能になる。
```
ネットワーク設定について  
```
ECS Fargateでは、ネットワークモードとして awsvpc しか使えない。 このモードの仕様上、「コンテナポートとホストポートは必ず同じ値にする」 という絶対的なルールがある。
```