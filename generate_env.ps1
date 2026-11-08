# Capturamos los outputs limpios de Terraform
$RDS      = terraform output -raw rds_endpoint
# $CDN      = terraform output -raw cloudfront_domain_name
$S3       = terraform output -raw aws_s3_bucket
$GCP_BKT  = terraform output -raw gcp_bucket

# Reemplazo para la sección de MediaConvert en tu .ps1
# $MC_URL = aws mediaconvert describe-endpoints --query "Endpoints[0].Url" --output text

# Ruta de la carpeta de la app
$RutaDestino = ".\proyecto-docker-ti"

# Armamos el texto del archivo .env
$envContent = @"
DB_HOST=$RDS
DB_PORT=5432
DB_NAME=edtech
DB_USER=db_admin
DB_PASSWORD=REPLACE_WITH_DB_PASSWORD
S3_BUCKET=$S3
GCP_BUCKET=$GCP_BKT
"@

# Lo guardamos forzando formato UTF-8 (el que entiende Docker)
$envContent | Out-File -FilePath .env -Encoding utf8

# Copiamos el archivo a la carpeta de la app
Copy-Item -Path ".\.env" -Destination "$RutaDestino\.env" -Force

Write-Host "¡Archivo .env generado con éxito!" -ForegroundColor Green
