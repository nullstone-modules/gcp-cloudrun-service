locals {
  service_name        = local.resource_name
  bootstrap_image_uri = "us-docker.pkg.dev/cloudrun/container/hello"
  effective_image_uri = local.app_version == "" ? local.bootstrap_image_uri : "${module.scaffold.repository_url}:${local.app_version}"
  main_container_name = "main"
  command             = length(var.command) > 0 ? var.command : null
}

resource "google_cloud_run_v2_service" "this" {
  name                = local.service_name
  location            = local.region
  labels              = local.labels
  ingress             = var.ingress
  deletion_protection = false

  template {
    service_account                  = module.scaffold.app_service_account.email
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    timeout                          = "${var.request_timeout_seconds}s"
    max_instance_request_concurrency = var.container_concurrency
    labels                           = local.labels

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    vpc_access {
      connector = local.vpc_access_connector_id
      egress    = var.vpc_egress
    }

    containers {
      name    = local.main_container_name
      image   = local.effective_image_uri
      command = local.command

      ports {
        name           = "http1"
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      # Environment variables
      dynamic "env" {
        for_each = local.all_env_vars

        content {
          name  = env.key
          value = env.value
        }
      }

      # Secret environment variables
      dynamic "env" {
        for_each = local.all_secrets

        content {
          name = env.key

          value_source {
            secret_key_ref {
              secret  = env.value
              version = "latest"
            }
          }
        }
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    google_secret_manager_secret_iam_member.secrets_access,
    google_secret_manager_secret_version.app_secret,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count = var.allow_unauthenticated ? 1 : 0

  project  = google_cloud_run_v2_service.this.project
  location = google_cloud_run_v2_service.this.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
