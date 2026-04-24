locals {
  metrics_mappings = concat(local.base_metrics, local.capabilities.metrics)

  // Resources
  // - https://cloud.google.com/stackdriver/docs/managed-prometheus/promql
  query_filter = "monitored_resource=\"cloud_run_revision\",service_name=\"${local.service_name}\""

  base_metrics = [
    {
      name = "app/cpu"
      type = "usage"
      unit = "cores"

      mappings = {
        cpu_reserved = {
          query = "avg(run_googleapis_com_container_cpu_allocation_time{${local.query_filter}})"
        }
        cpu_average = {
          query = "(avg(run_googleapis_com_container_cpu_utilizations{${local.query_filter}}))*(avg(run_googleapis_com_container_cpu_allocation_time{${local.query_filter}}))"
        }
        cpu_min = {
          query = "(min(run_googleapis_com_container_cpu_utilizations{${local.query_filter}}))*(avg(run_googleapis_com_container_cpu_allocation_time{${local.query_filter}}))"
        }
        cpu_max = {
          query = "(max(run_googleapis_com_container_cpu_utilizations{${local.query_filter}}))*(avg(run_googleapis_com_container_cpu_allocation_time{${local.query_filter}}))"
        }
      }
    },
    {
      name = "app/memory"
      type = "usage"
      unit = "MiB"

      mappings = {
        memory_reserved = {
          query = "(avg(run_googleapis_com_container_memory_allocation_time{${local.query_filter}}))/1048576"
        }
        memory_average = {
          query = "(avg(run_googleapis_com_container_memory_utilizations{${local.query_filter}}))*(avg(run_googleapis_com_container_memory_allocation_time{${local.query_filter}}))/1048576"
        }
        memory_min = {
          query = "(min(run_googleapis_com_container_memory_utilizations{${local.query_filter}}))*(avg(run_googleapis_com_container_memory_allocation_time{${local.query_filter}}))/1048576"
        }
        memory_max = {
          query = "(max(run_googleapis_com_container_memory_utilizations{${local.query_filter}}))*(avg(run_googleapis_com_container_memory_allocation_time{${local.query_filter}}))/1048576"
        }
      }
    },
    {
      name = "app/requests"
      type = "usage"
      unit = "count"

      mappings = {
        requests_total = {
          query = "sum(rate(run_googleapis_com_request_count{${local.query_filter}}[1m]))"
        }
        requests_2xx = {
          query = "sum(rate(run_googleapis_com_request_count{${local.query_filter},response_code_class=\"2xx\"}[1m]))"
        }
        requests_4xx = {
          query = "sum(rate(run_googleapis_com_request_count{${local.query_filter},response_code_class=\"4xx\"}[1m]))"
        }
        requests_5xx = {
          query = "sum(rate(run_googleapis_com_request_count{${local.query_filter},response_code_class=\"5xx\"}[1m]))"
        }
      }
    },
    {
      name = "app/latency"
      type = "duration"
      unit = "ms"

      mappings = {
        latency_p50 = {
          query = "histogram_quantile(0.50, sum(rate(run_googleapis_com_request_latencies_bucket{${local.query_filter}}[1m])) by (le))"
        }
        latency_p95 = {
          query = "histogram_quantile(0.95, sum(rate(run_googleapis_com_request_latencies_bucket{${local.query_filter}}[1m])) by (le))"
        }
        latency_p99 = {
          query = "histogram_quantile(0.99, sum(rate(run_googleapis_com_request_latencies_bucket{${local.query_filter}}[1m])) by (le))"
        }
      }
    },
    {
      name = "app/instances"
      type = "usage"
      unit = "count"

      mappings = {
        instances_active = {
          query = "sum(run_googleapis_com_container_instance_count{${local.query_filter},state=\"active\"})"
        }
        instances_idle = {
          query = "sum(run_googleapis_com_container_instance_count{${local.query_filter},state=\"idle\"})"
        }
      }
    },
  ]
}
