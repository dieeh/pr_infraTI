variable "aws_region" {
  type        = string
  description = "Región por defecto de AWS para el despliegue principal"
  default     = "us-east-1"
}

variable "gcp_project" {
  type        = string
  description = "El ID del proyecto de Google Cloud donde se creará el bucket"
}

variable "gcp_region" {
  type        = string
  description = "Región de Google Cloud para los recursos de almacenamiento"
  default     = "us-central1"
}

variable "my_ip" {
  type        = string
  description = "Tu IP pública en formato CIDR (ej: 190.100.50.25/32) para restringir el acceso SSH"
}

variable "key_name" {
  type        = string
  description = "Nombre lógico del Key Pair para las instancias EC2"
  default     = "pi-key"
}

variable "public_key_path" {
  type        = string
  description = "Ruta local del archivo de clave pública SSH (.pub)"
  default     = "C:/Users/diego/.ssh/pi-key.pub"
}

variable "gcp_credentials_path" {
  type        = string
  description = "Ruta local al archivo JSON de la Service Account de GCP"
  default     = "keys/backups-multicloud-500206-5f8fb2b9e436.json"
}
