variable "common_labels" {
  type = map(any)
  default = {
    "creator" = "terraform"
  }
}