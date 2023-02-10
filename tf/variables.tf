variable "do_token" {
  description = "DigitalOcean Personal Access Token"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "Namespace prefix for DigitalOcean resources"
  type        = string
}