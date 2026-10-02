# 0.3.0 (Oct 2, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.13.0`.
* Replaced `ns_env_variables` and `ns_secret_keys` with the layered `ns_env_layout`, `ns_env_values`, and `ns_env_platform_data` data sources to aggregate environment variables and secrets.
* Emitted the `env` platform data record, including the source of each variable and the Secret Manager secret id of each managed secret.
* Reported the variables Cloud Run injects into the service (`K_SERVICE`, `PORT`) in the `cloud` layer of the `env` platform data record.
* Upgraded capability scaffolding to emit `capability` on capability outputs and `cap_prefixes`.

# 0.2.0 (Jun 19, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.11.0`.
* Used `gcp_labels` from `data.ns_workspace` to label resources.

# 0.1.8 (Jun 08, 2026)
* Added `GOOGLE_CLOUD_REGION` env var to app.

# 0.1.7 (Jun 03, 2026)
* Added `service_audience` output.

# 0.1.6 (Jun 03, 2026)
* Added `GOOGLE_SERVICE_AUDIENCE` environment variable.
* Added custom audience `https://<app-name>`.

# 0.1.5 (Jun 03, 2026)
* Removed `GOOGLE_SERVICE_URL` to environment variables to avoid cycle.

# 0.1.4 (Jun 03, 2026)
* Added `GOOGLE_SERVICE_URL` to environment variables.

# 0.1.3 (May 20, 2026)
* Redesign capabilities scaffold to prevent circular dependencies.

# 0.1.2 (May 20, 2026)
* Added `post_app_metadata` for capabilities to use metadata from the created service infra.

# 0.1.1 (May 15, 2026)
* Fixed secrets interpolation when secret value contains "$".

# 0.1.0 (Apr 29, 2026)
* Initial release
