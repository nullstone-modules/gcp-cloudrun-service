module "scaffold" {
  source = "registry.terraform.io/nullstone-modules/cloudrun-appscaffold/google"

  project_id             = local.project_id
  region                 = local.region
  app_name               = local.app_name
  block_ref              = local.block_ref
  resource_suffix        = random_string.resource_suffix.result
  repo_labels            = local.repo_labels
  op_impersonater_emails = [local.ns_agent_service_account_email]
}
