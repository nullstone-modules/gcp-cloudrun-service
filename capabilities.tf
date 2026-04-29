// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  cap_modules = [
    {
      name       = ""
      tfId       = ""
      namespace  = ""
      env_prefix = ""
      outputs    = {}

      meta = {
        subcategory = ""
        platform    = ""
        subplatform = ""
        outputNames = []
      }
    }
  ]

  // cap_env_prefixes is a map indexed by tfId which points to the env_prefix in local.cap_modules
  cap_env_prefixes = tomap({
    x = ""
  })

  capabilities = {
    env = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = ""
      }
    ]

    secrets = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = sensitive("")
      }
    ]

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        cap_tf_id = "x"
        url       = "http://example"
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        cap_tf_id = "x"
        url       = "https://example.com"
      }
    ]

    // metrics allows capabilities to attach metrics to the application
    // These metrics are displayed on the Application Monitoring page
    // See https://docs.nullstone.io/extending/metrics/overview.html
    metrics = [
      {
        cap_tf_id = "x"
        name      = ""
        type      = "usage|usage-percent|duration|generic"
        unit      = ""

        mappings = jsonencode({})
      }
    ]

    // Cloud Run v2 supports at most one startup_probe per container.
    // Probe action types: http_get, tcp_socket, grpc. (exec is not supported.)
    startup_probes = [
      {
        cap_tf_id             = "x"
        initial_delay_seconds = null
        period_seconds        = null
        timeout_seconds       = null
        failure_threshold     = null

        grpc = jsonencode({
          port    = 9000
          service = "myservice"
        })
        http_get = jsonencode({
          path = "/"
          port = 8080
        })
        tcp_socket = jsonencode({
          port = 8080
        })
      }
    ]

    // Cloud Run v2 supports at most one liveness_probe per container.
    // Probe action types: http_get, grpc. (tcp_socket and exec are not supported.)
    liveness_probes = [
      {
        cap_tf_id             = "x"
        initial_delay_seconds = null
        period_seconds        = null
        timeout_seconds       = null
        failure_threshold     = null

        grpc = jsonencode({
          port    = 9000
          service = "myservice"
        })
        http_get = jsonencode({
          path = "/"
          port = 8080
        })
      }
    ]
  }
}
