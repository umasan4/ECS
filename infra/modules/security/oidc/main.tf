# ---------------------------------------------
# OIDC Provider
# ---------------------------------------------
# GitHubのサーバー証明書
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# 外部のIdPをAWS IAMに登録
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # サムプリント(=証明書のハッシュ値)を取得する
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

# ---------------------------------------------
# IAM Role
# ---------------------------------------------
resource "aws_iam_role" "github_actions" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Principal = { Federated = aws_iam_openid_connect_provider.github.arn } # OIDCで認証されたリクエストのみ許可
        Condition = {
          StringLike   = { "token.actions.githubusercontent.com:sub" : "repo:${var.github_repo}:*" } # 特定のリポジトリからのリクエストのみ許可
          StringEquals = { "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com" }         # 宛先(Audience)がAWSであることを確認
        }
      }
    ]
  })
}

# ---------------------------------------------
# IAM Policy Attachment
# ---------------------------------------------
resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = var.policy_arn
}