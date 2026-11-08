# # --- COMPONENTE DE TRANSCODIFICACIÓN (AWS ELEMENTAL MEDIACONVERT) ---
# resource "aws_iam_role" "mediaconvert_role" {
#   name = "pi-edtech-mediaconvert-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "mediaconvert.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "mc_s3_access" {
#   role       = aws_iam_role.mediaconvert_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }
#
#  resource "aws_media_convert_queue" "video_queue" {
#    name   = "pi-edtech-video-queue"
#    status = "ACTIVE"
#  }
#
# # --- DISTRIBUCIÓN DE CONTENIDO (AWS CLOUDFRONT CDN) ---
# resource "aws_cloudfront_origin_access_control" "oac" {
#   name                              = "pi-cloudfront-oac"
#   description                       = "Acceso seguro desde la CDN al Bucket de S3"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }
#
# resource "aws_cloudfront_distribution" "s3_distribution" {
#   origin {
#     domain_name              = aws_s3_bucket.media_bucket.bucket_regional_domain_name
#     origin_id                = "S3-${aws_s3_bucket.media_bucket.id}"
#     origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
#   }
#
#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "CDN para distribucion de video streaming de la EdTech"
#   default_root_object = "index.html"
#
#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#    cached_methods   = ["GET", "HEAD"]
#    target_origin_id = "S3-${aws_s3_bucket.media_bucket.id}"
#
#    forwarded_values {
#      query_string = false
#      cookies {
#        forward = "none"
#      }
#    }
#
#    viewer_protocol_policy = "redirect-to-https"
#    min_ttl                = 0
#    default_ttl            = 3600
#    max_ttl                = 86400
#   }
#
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }
#
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
#
#   tags = {
#     Name = "pi-edtech-cdn"
#   }
# }
#
