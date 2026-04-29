// Cloud Run v2 supports at most one startup_probe and one liveness_probe per container.
// It does not support readiness_probe, and probes do not support exec actions.
// We pass through capability-provided probes; if a capability supplies more than one,
// the provider will reject the apply with a clear error.
locals {
  startup_probes = [
    for p in local.capabilities.startup_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds", null)
      period_seconds        = lookup(p, "period_seconds", null)
      timeout_seconds       = lookup(p, "timeout_seconds", null)
      failure_threshold     = lookup(p, "failure_threshold", null)

      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
  liveness_probes = [
    for p in local.capabilities.liveness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds", null)
      period_seconds        = lookup(p, "period_seconds", null)
      timeout_seconds       = lookup(p, "timeout_seconds", null)
      failure_threshold     = lookup(p, "failure_threshold", null)

      grpc     = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
    }
  ]
}
