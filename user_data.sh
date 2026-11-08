#!/bin/bash
# 1. Actualización y dependencias básicas
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release unzip awscli jq

echo "AWS_DEFAULT_REGION=us-east-1" >> /etc/environment
echo "AWS_REGION=us-east-1" >> /etc/environment

# También la dejamos configurada en el perfil local del usuario ubuntu por si acaso
mkdir -p /home/ubuntu/.aws
sudo -u ubuntu aws configure set region us-east-1

# 2. Instalación de Docker y Docker Compose
# Añadir repositorio oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 3. Instalación de Google Cloud CLI (necesaria para tus backups a GCP)
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
apt-get update -y && apt-get install -y google-cloud-cli

# 4. Ajustes de permisos (importante para Docker)
usermod -aG docker ubuntu

# 5. (Opcional) Nginx
# Solo instálalo si vas a usarlo como Reverse Proxy delante de tus contenedores.
# Si tu Frontend ya se sirve solo, puedes quitar estas líneas para ahorrar RAM.
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

echo "VM configurada con éxito: Docker, AWS CLI y GCloud CLI instalados." > /etc/motd
