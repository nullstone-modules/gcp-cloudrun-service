variable "cpu" {
  type        = string
  default     = "1"
  description = <<EOF
The number of CPU units to allocate to the container.
Can be specified in vCPUs (e.g., "1") or millivCPUs (e.g., "1000m").
Default is 1 vCPU.
EOF
}

variable "memory" {
  type        = string
  default     = "512Mi"
  description = <<EOF
The amount of memory to allocate to the container.
Can be specified in bytes (e.g., "536870912") or with a suffix (e.g., "512Mi", "2Gi").
Default is 512Mi.
EOF
}

variable "cpu_idle" {
  type        = bool
  default     = true
  description = <<EOF
Controls whether CPU is allocated only during request processing or kept always-on.
  - true (default): CPU is throttled between requests. Cheaper, but background work (timers, queue consumers, websocket pings) will not run reliably between requests.
  - false: CPU is always allocated for the lifetime of an instance. Required for long-running background work, websocket keepalives, or any service that must do work outside of a request.
Default is true.
EOF
}

variable "command" {
  type        = list(string)
  default     = []
  description = <<EOF
Entrypoint array (command to execute when the container starts).
If not specified, the container image's ENTRYPOINT is used.
Each token in the command is an item in the list.
For example, `echo "Hello World"` would be represented as ["echo", "Hello World"].
EOF
}

variable "container_port" {
  type        = number
  default     = 8080
  description = <<EOF
The port the container listens on for HTTP requests.
Cloud Run forwards incoming requests to this port via the `PORT` environment variable.
Default is 8080.
EOF
}

variable "container_concurrency" {
  type        = number
  default     = 80
  description = <<EOF
Maximum number of concurrent requests handled by a single container instance.
Set to 1 to force request isolation (one request per instance at a time).
Default is 80.
EOF
}

variable "request_timeout_seconds" {
  type        = number
  default     = 300
  description = <<EOF
Maximum number of seconds a request is allowed to run before being terminated.
Must be between 1 and 3600 (1 hour).
Default is 300 seconds (5 minutes).
EOF
}

variable "min_instances" {
  type        = number
  default     = 0
  description = <<EOF
Minimum number of container instances kept warm.
Set to 0 to allow scale-to-zero (incurs cold starts on first request).
Set to 1 or higher to keep at least that many instances always-on.
Default is 0.
EOF
}

variable "max_instances" {
  type        = number
  default     = 100
  description = <<EOF
Maximum number of container instances the service can scale up to.
Default is 100.
EOF
}
