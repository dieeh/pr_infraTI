# Generador de sufijos aleatorios para evitar colisiones de nombres globales en S3
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# --- ALMACENAMIENTO DE BLOQUES Y SNAPSHOTS ---
resource "aws_ebs_volume" "data_vol" {
  availability_zone = aws_instance.vm_app.availability_zone
  size              = 8
  type              = "gp2"
  tags = {
    Name = "pi-data-volume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.data_vol.id
  instance_id  = aws_instance.vm_app.id
  force_detach = true
  depends_on = [
    aws_instance.vm_app,
    aws_ebs_volume.data_vol
  ]
}

resource "aws_ebs_snapshot" "data_snapshot" {
  volume_id = aws_ebs_volume.data_vol.id
  tags = {
    Name      = "data-backup-snapshot"
    Retention = "7d"
  }
  depends_on = [aws_volume_attachment.ebs_att]
  lifecycle {
    create_before_destroy = true
  }
}

# --- REPOSITORIOS MULTICLOUD (AWS S3 & GOOGLE CLOUD STORAGE) ---
resource "aws_s3_bucket" "media_bucket" {
  bucket        = "pi-media-${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket" "backup_bucket" {
  bucket        = "pi-backup-${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_policy" "media_bucket_policy" {
#   bucket = aws_s3_bucket.media_bucket.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCloudFrontServicePrincipal"
#         Effect = "Allow"
#
#         Principal = {
#           Service = "cloudfront.amazonaws.com"
#         }
#
#         Action = "s3:GetObject"
#
#         Resource = "${aws_s3_bucket.media_bucket.arn}/*"
#
#         Condition = {
#           StringEquals = {
#             "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
#           }
#         }
#       }
#     ]
#   })
# }

resource "google_storage_bucket" "gcs_backup_bucket" {
  name                        = "backups-multicloud-${var.gcp_project}-pi-dr-backup"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}
