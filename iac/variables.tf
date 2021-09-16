variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "dataopsdev"
}
variable "location" {
  description = "Azure location"
  type        = string
  default     = "westeurope"
}
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    group     = "dataops-test",
    environment = "dev"
  }
}
