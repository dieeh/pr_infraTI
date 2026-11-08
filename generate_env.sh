#!/bin/bash

# 1. Obtener los outputs de Terraform (asegúrate de estar en la carpeta donde está el .tfstate)
RDS=$(terraform output -raw rds_endpoint)
# CDN=$(terraform output -raw cloudfront_domain_name)
S3=$(terraform output -raw aws_s3_bucket)
GCP_BKT=$(terraform output -raw gcp_bucket)

# 2. ¡La magia! Consultamos el endpoint directamente a AWS mediante la CLI
echo "Consultando endpoint de MediaConvert a AWS..."
# MC_URL=$(aws mediaconvert describe-endpoints --query "Endpoints[0].Url" --output text)

# 2. Definir la carpeta destino (ajusta si tu carpeta se llama distinto)
DEST_DIR="proyecto-docker-ti"

# 3. Crear el contenido del archivo .env usando un heredoc
cat <<EOF > .env
DB_HOST=$RDS
DB_PORT=5432
DB_NAME=edtech
DB_USER=db_admin
DB_PASSWORD=REPLACE_WITH_DB_PASSWORD

S3_BUCKET=$S3

GCP_BUCKET=$GCP_BKT
EOF

# 4. Copiar el archivo a la carpeta destino
if [ -d "$DEST_DIR" ]; then
    cp .env "$DEST_DIR/.env"
    echo "¡Archivo .env generado y copiado a $DEST_DIR exitosamente!"
else
    echo "Error: La carpeta de destino $DEST_DIR no existe. Verifica la ruta."
fi
