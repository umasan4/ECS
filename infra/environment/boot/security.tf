module "oidc" {
  source      = "../../modules/security/oidc"
  github_repo = var.github_repo
  role_name   = var.role_name
  policy_arn  = var.policy_arn
}