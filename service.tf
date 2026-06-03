locals {
  service_name        = local.resource_name
  bootstrap_image_uri = "us-docker.pkg.dev/cloudrun/container/hello"
  effective_image_uri = local.app_version == "" ? local.bootstrap_image_uri : "${module.scaffold.repository_url}:${local.app_version}"
  main_container_name = "main"
  command             = length(var.command) > 0 ? var.command : null
  service_audience    = "https://${local.app_name}"
}

resource "google_cloud_run_v2_service" "this" {
  name                = local.service_name
  location            = local.region
  labels              = local.labels
  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  custom_audiences    = [local.service_audience]
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
      egress    = "PRIVATE_RANGES_ONLY"
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
        cpu_idle          = var.cpu_idle
        startup_cpu_boost = true
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

      # Startup probe (Cloud Run supports at most one)
      dynamic "startup_probe" {
        for_each = local.startup_probes
        iterator = sp

        content {
          initial_delay_seconds = sp.value.initial_delay_seconds
          period_seconds        = sp.value.period_seconds
          timeout_seconds       = sp.value.timeout_seconds
          failure_threshold     = sp.value.failure_threshold

          dynamic "http_get" {
            for_each = sp.value.http_get
            content {
              path = lookup(http_get.value, "path", null)
              port = lookup(http_get.value, "port", null)

              dynamic "http_headers" {
                for_each = compact(lookup(http_get.value, "http_headers", []))
                iterator = header

                content {
                  name  = header.value.name
                  value = header.value.value
                }
              }
            }
          }

          dynamic "tcp_socket" {
            for_each = sp.value.tcp_socket
            content {
              port = tcp_socket.value.port
            }
          }

          dynamic "grpc" {
            for_each = sp.value.grpc
            content {
              port    = grpc.value.port
              service = lookup(grpc.value, "service", null)
            }
          }
        }
      }

      # Liveness probe (Cloud Run supports at most one)
      dynamic "liveness_probe" {
        for_each = local.liveness_probes
        iterator = lp

        content {
          initial_delay_seconds = lp.value.initial_delay_seconds
          period_seconds        = lp.value.period_seconds
          timeout_seconds       = lp.value.timeout_seconds
          failure_threshold     = lp.value.failure_threshold

          dynamic "http_get" {
            for_each = lp.value.http_get
            content {
              path = lookup(http_get.value, "path", null)
              port = lookup(http_get.value, "port", null)

              dynamic "http_headers" {
                for_each = compact(lookup(http_get.value, "http_headers", []))
                iterator = header

                content {
                  name  = header.value.name
                  value = header.value.value
                }
              }
            }
          }

          dynamic "grpc" {
            for_each = lp.value.grpc
            content {
              port    = grpc.value.port
              service = lookup(grpc.value, "service", null)
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

    precondition {
      condition     = length(local.startup_probes) <= 1
      error_message = "Cloud Run v2 supports at most one startup_probe per container, but ${length(local.startup_probes)} were provided via capabilities. Remove the extra startup_probe capability."
    }

    precondition {
      condition     = length(local.liveness_probes) <= 1
      error_message = "Cloud Run v2 supports at most one liveness_probe per container, but ${length(local.liveness_probes)} were provided via capabilities. Remove the extra liveness_probe capability."
    }
  }
}
