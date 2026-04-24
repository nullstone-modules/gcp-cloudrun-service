locals {
  // Private and public URLs are shown in the Nullstone UI
  // Typically, they are created through capabilities attached to the application
  // If this module has URLs, add them here as list(string)
  //
  // The service's auto-assigned `*.run.app` URL is classified by ingress:
  //   - INGRESS_TRAFFIC_ALL -> public (reachable from the internet, subject to IAM)
  //   - INGRESS_TRAFFIC_INTERNAL_ONLY / INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER -> private (reachable only from same-VPC/LB)
  service_uri_is_public   = var.ingress == "INGRESS_TRAFFIC_ALL"
  additional_private_urls = local.service_uri_is_public ? [] : [google_cloud_run_v2_service.this.uri]
  additional_public_urls  = local.service_uri_is_public ? [google_cloud_run_v2_service.this.uri] : []

  private_urls = concat([for cur in local.capabilities.private_urls : cur.url], local.additional_private_urls)
  public_urls  = concat([for cur in local.capabilities.public_urls : cur.url], local.additional_public_urls)
}

locals {
  uri_matcher = "^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?"
}

locals {
  authority_matcher = "^(?:(?P<user>[^@]*)@)?(?:(?P<host>[^:]*))(?:[:](?P<port>[\\d]*))?"
  // These tests are here to verify the authority_matcher regex above
  // To verify, uncomment the following lines and issue "echo 'local.tests' | terraform console"
  /*
  tests = tomap({
    "nullstone.io" : regex(local.authority_matcher, "nullstone.io"),
    "brad@nullstone.io" : regex(local.authority_matcher, "brad@nullstone.io"),
    "brad:password@nullstone.io" : regex(local.authority_matcher, "brad:password@nullstone.io"),
    "nullstone.io:9000" : regex(local.authority_matcher, "nullstone.io:9000"),
    "brad@nullstone.io:9000" : regex(local.authority_matcher, "brad@nullstone.io:9000"),
    "brad:password@nullstone.io:9000" : regex(local.authority_matcher, "brad:password@nullstone.io:9000"),
  })
  */
}

locals {
  private_hosts = [for url in local.private_urls : lookup(regex(local.authority_matcher, lookup(regex(local.uri_matcher, url), "authority")), "host")]
  public_hosts  = [for url in local.public_urls : lookup(regex(local.authority_matcher, lookup(regex(local.uri_matcher, url), "authority")), "host")]
}
