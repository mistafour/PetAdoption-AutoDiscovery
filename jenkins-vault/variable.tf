
variable "domain" {
 
  description = "The domain name for our pet adoption project"
  type        = string
  default     = "" # without https 
}
variable "region" {
  default = "eu-west-3"
}