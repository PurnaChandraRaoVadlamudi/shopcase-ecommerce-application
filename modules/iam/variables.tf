# ===================================================================
# IAM Variables - Production Grade
# ===================================================================

variable "env" {
  description = "Environment name (prod, staging, dev)"
  type        = string
}

variable "admin_principal_arn" {
  description = "ARN of the principal that can assume admin role"
  type        = string
  default     = ""
}

variable "dev_principal_arn" {
  description = "ARN of the principal that can assume developer role"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}