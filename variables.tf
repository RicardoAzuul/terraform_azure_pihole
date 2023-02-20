variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "resource_prefix" {
  default     = "rtb"
  description = "Prefix of the resources in this plan to make them unique."
}