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

variable "ingress" {
  type        = string
  default     = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  description = <<EOF
Controls which traffic sources can reach this service.
  - INGRESS_TRAFFIC_ALL: public internet (subject to IAM invoker policy)
  - INGRESS_TRAFFIC_INTERNAL_ONLY: same-VPC traffic, in-project GCP services, PubSub/Eventarc
  - INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER: internal sources plus Google Cloud external HTTPS load balancer
Default is INGRESS_TRAFFIC_INTERNAL_ONLY. To expose publicly, use a capability that provisions a GCLB or set ingress to INGRESS_TRAFFIC_ALL.
EOF

  validation {
    condition     = contains(["INGRESS_TRAFFIC_ALL", "INGRESS_TRAFFIC_INTERNAL_ONLY", "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"], var.ingress)
    error_message = "ingress must be one of INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, or INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER."
  }
}

variable "allow_unauthenticated" {
  type        = bool
  default     = false
  description = <<EOF
When true, grants `roles/run.invoker` to `allUsers`, letting unauthenticated callers invoke the service.
Combined with `ingress = INGRESS_TRAFFIC_ALL`, this makes the service publicly reachable without auth.
Has no effect when ingress restricts traffic to internal sources.
Default is false.
EOF
}

variable "vpc_egress" {
  type        = string
  default     = "PRIVATE_RANGES_ONLY"
  description = <<EOF
Controls which outbound traffic is routed through the VPC connector.
  - PRIVATE_RANGES_ONLY: only traffic to RFC1918 ranges uses the connector; public-internet egress bypasses the VPC
  - ALL_TRAFFIC: all outbound traffic uses the connector (required for VPC-level egress controls, Private Google Access, etc.)
Default is PRIVATE_RANGES_ONLY.
EOF

  validation {
    condition     = contains(["PRIVATE_RANGES_ONLY", "ALL_TRAFFIC"], var.vpc_egress)
    error_message = "vpc_egress must be either PRIVATE_RANGES_ONLY or ALL_TRAFFIC."
  }
}
