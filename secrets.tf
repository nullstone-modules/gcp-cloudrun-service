resource "google_secret_manager_secret" "app_secret" {
  for_each = local.managed_secret_keys

  // Valid secret_id: [[a-zA-Z_0-9]+]
  secret_id = lower(replace("${local.resource_name}_${each.value}", "/[^a-zA-Z_0-9]/", "_"))
  labels    = local.labels

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "app_secret" {
  for_each = local.managed_secret_keys

  secret      = google_secret_manager_secret.app_secret[each.value].id
  secret_data = local.managed_secret_values[each.value]
}

# Grant the app runtime SA access to every secret the workload references
# (both managed secrets from this module and unmanaged `{{ secret(...) }}` refs).
resource "google_secret_manager_secret_iam_member" "secrets_access" {
  for_each = local.all_secret_keys

  secret_id = local.all_secrets[each.value]
  project   = local.project_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${module.scaffold.app_service_account.email}"
}
