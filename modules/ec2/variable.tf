variable "maintainer" {
  description = "Auteur"
  type        = string
  default     = "daniel"
}

variable "instance_type" {
  description = "Choix du type d'instance"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key" {
  description = "Pair de clé"
  type        = string
  default     = "KeyPairDanielCertif"
}

variable "allow_ssh_http_https" {
  description = "Choix de la valeur par défaut des ports"
  type        = string
  default     = "Null"
}

variable "public_ip" {
  description = "Choix de l'adresse ip publique par défaut"
  type        = string
  default     = "Null"
}

variable "user" {
  description = "Nom de notre utilisateur"
  type        = string
  default     = "ubuntu"
}

variable "AZ" {
  description = "Zone de disponibilité choisie"
  type        = string
  default     = "us-east-1a"
}
