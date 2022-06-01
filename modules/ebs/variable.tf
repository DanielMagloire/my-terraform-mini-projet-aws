variable "disk_size" {
  description = "Taille du disque choisie"
  type        = number
  default     = 2
}
variable "maintainer" {
  description = "Auteur"
  type        = string
  default     = "daniel"
}

variable "AZ" {
  description = "Zone de disponibilité choisie"
  type        = string
  default     = "us-east-1a"
}
