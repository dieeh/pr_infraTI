output "vm_app_public_ip" {
  description = "Dirección IP pública de la instancia de aplicación"
  value       = aws_instance.vm_app.public_ip
}

output "vm_backup_public_ip" {
  description = "Dirección IP pública de la instancia de administración/respaldo"
  value       = aws_instance.vm_backup.public_ip
}

output "aws_s3_bucket" {
  description = "Identificador del bucket S3 de almacenamiento temporal en AWS"
  value       = aws_s3_bucket.backup_bucket.id
}

output "gcp_bucket" {
  description = "Identificador del bucket GCS en Google Cloud"
  value       = google_storage_bucket.gcs_backup_bucket.name
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres_db.endpoint
  description = "Endpoint de conexión para la base de datos de producción (Inyectar en Docker Compose)"
}

# output "cloudfront_domain_name" {
#   value       = aws_cloudfront_distribution.s3_distribution.domain_name
#   description = "URL publica de la CDN para embeber los videos en el Frontend"
# }
