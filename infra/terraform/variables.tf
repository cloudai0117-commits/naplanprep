variable "location" {
  description = "Primary Azure region for all resources."
  type        = string
  default     = "australiaeast"
}

variable "dr_location" {
  description = "Disaster recovery / secondary region (used for geo-replication)."
  type        = string
  default     = "australiasoutheast"
}

variable "environment" {
  description = "Deployment environment label (prod | uat | dev)."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "uat", "dev"], var.environment)
    error_message = "environment must be one of: prod, uat, dev."
  }
}

variable "project" {
  description = "Short project prefix used in resource names."
  type        = string
  default     = "npp"
}

# ─── PostgreSQL ───────────────────────────────────────────────────────────────

variable "postgresql_admin_username" {
  description = "Administrator login for PostgreSQL Flexible Server."
  type        = string
  default     = "naplanprep_admin"
}

variable "postgresql_admin_password" {
  description = "Administrator password for PostgreSQL Flexible Server. Store in Key Vault; supply via TF_VAR_postgresql_admin_password or var file that is NOT committed."
  type        = string
  sensitive   = true
}

variable "postgresql_sku_name" {
  description = "SKU for PostgreSQL Flexible Server (e.g. GP_Standard_D4s_v3)."
  type        = string
  default     = "GP_Standard_D4s_v3"
}

variable "postgresql_version" {
  description = "PostgreSQL engine version. Must match the version validated by Flyway migrations."
  type        = string
  default     = "16"
}

# ─── Container App ────────────────────────────────────────────────────────────

variable "container_app_image" {
  description = "Full image reference for the backend Container App (e.g. npprodacr.azurecr.io/naplanprep-backend:prod-abc12345). Updated per deployment."
  type        = string
}

variable "stripe_publishable_key" {
  description = "Stripe publishable key (live mode). This is NOT a secret — it is exposed to the browser via the frontend build. Do not put it in Key Vault."
  type        = string
}

# ─── GitHub Actions OIDC ──────────────────────────────────────────────────────

variable "github_repo" {
  description = "GitHub repository in org/repo format (e.g. myorg/naplanprep). Used for OIDC federated credential subject."
  type        = string
}

variable "github_actions_environment" {
  description = "GitHub Actions environment name used in the OIDC subject claim."
  type        = string
  default     = "production"
}

# ─── Monitoring ───────────────────────────────────────────────────────────────

variable "alert_email" {
  description = "Email address for Azure Monitor alert notifications."
  type        = string
}
