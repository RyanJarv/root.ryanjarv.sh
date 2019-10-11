module "me_ryanjarv_sh" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name          = "me@ryanjarv.sh"
  pgp_key       = "keybase:jarv"
  groups        = "${local.admin_groups}"
  force_destroy = "true"
}

output "me@ryanjarv.sh" {
  description = "Decrypt command"
  value       = "${module.me_ryanjarv_sh.keybase_password_decrypt_command}"
}
