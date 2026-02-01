variable "location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "gallery_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
