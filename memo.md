## terrafom に関係する部分

# --provider--
terraform {
  # ここには、terraform 本体のバージョンを指定する
  # バージョンの確認方法は、terraform --version
  required_version = ">= 1.5.0, < 2.0.0"

  # インフラプロバイダのバージョン(AWS)
  # バージョンの確認方法は、terraform レジストリを確認する
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
  }
}

# --リモートバックエンドの作成方法--
ローカルでS3, DynameDBを作成する
作成したものを、バックエンドに切り替える