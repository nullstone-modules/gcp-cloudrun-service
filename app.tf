data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_name    = data.ns_workspace.this.block_name
  app_version = data.ns_app_env.this.version
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. service_account_id)
    service_account_id    = module.scaffold.app_service_account.id
    service_account_email = module.scaffold.app_service_account.email
    service_name          = local.service_name
    service_id            = "projects/${local.project_id}/locations/${local.region}/services/${local.service_name}"
  })

  post_app_metadata = tomap({
    service_url = google_cloud_run_v2_service.this.uri
  })
}
