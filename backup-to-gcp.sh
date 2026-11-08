#!/bin/bash
set -euo pipefail

# 1. Cargar el entorno (Trae $S3_BUCKET y $GCP_BUCKET automáticamente)
ENV_PATH="/home/ubuntu/proyecto-docker-ti/.env"

if [ -f "$ENV_PATH" ]; then
    source "$ENV_PATH"
else
    echo "ERROR: No se encontró el archivo .env en $ENV_PATH"
    exit 1
fi

# 2. Variables fijas del sistema de archivos
SOURCE_DIR="/home/ubuntu/proyecto-docker-ti"
BACKUP_DIR="/tmp/local_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="edtech_backup_$TIMESTAMP.tar.gz"
GCP_KEY_FILE="/home/ubuntu/keys/gcp-key.json"

# 2. Compresión de datos.
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" .

# 3. Subida a nube principal (AWS S3).
aws s3 cp "$BACKUP_DIR/$BACKUP_NAME" "s3://$S3_BUCKET/$BACKUP_NAME"

# 4. Autenticación y subida a nube secundaria (GCP).
export GOOGLE_APPLICATION_CREDENTIALS="$GCP_KEY_FILE"
gcloud storage cp "$BACKUP_DIR/$BACKUP_NAME" "gs://$GCP_BUCKET/$BACKUP_NAME"

# 5. Limpieza.
rm "$BACKUP_DIR/$BACKUP_NAME"
