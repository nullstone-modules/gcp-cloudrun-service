output "image_repo_url" {
  value       = module.scaffold.repository_url
  description = "string ||| Service container image url."
}

output "project_id" {
  value       = local.project_id
  description = "string ||| The GCP Project ID hosting this Cloud Run Service"
}

output "region" {
  value       = local.region
  description = "string ||| The GCP region where this Cloud Run Service is hosted"
}

output "log_provider" {
  value       = "cloudlogging"
  description = "string ||| The log provider used for this service."
}

output "log_reader" {
  value       = module.scaffold.log_reader
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to stream logs from this Cloud Run Service."
}

output "log_filter" {
  value       = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${local.service_name}\""
  description = "string ||| A log filter used to filter Cloud Logging entries for this Cloud Run Service"
}

output "metrics_provider" {
  value       = "cloudmonitoring"
  description = "string ||| "
}

output "metrics_reader" {
  value       = module.scaffold.metrics_reader
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to view metrics for this application."
}

output "metrics_mappings" {
  value       = local.metrics_mappings
  description = "string ||| A mapping of metric definitions used to render app metrics in the Nullstone UI."
}

output "service_id" {
  value       = google_cloud_run_v2_service.this.id
  description = "string ||| The ID of the Cloud Run service. (projects/{project_id}/locations/{location}/services/{service_name})"
}

output "service_name" {
  value       = google_cloud_run_v2_service.this.name
  description = "string ||| The name of the Cloud Run service."
}

output "service_uri" {
  value       = google_cloud_run_v2_service.this.uri
  description = "string ||| The auto-assigned URL of the Cloud Run service (e.g. https://{service_name}-{hash}-{region}.run.app). Reachability depends on var.ingress."
}

output "image_pusher" {
  value       = module.scaffold.image_pusher
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account that is allowed to push images."
}

output "deployer" {
  value       = module.scaffold.deployer
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to deploy this Cloud Run service."
}

output "main_container_name" {
  value       = local.main_container_name
  description = "string ||| The name of the container definition for the primary container"
}

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}
