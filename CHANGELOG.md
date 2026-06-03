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
