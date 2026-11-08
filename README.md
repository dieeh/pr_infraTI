# Infraestructura Multicloud para Plataforma EdTech

Proyecto académico de infraestructura y despliegue para una plataforma educativa (EdTech), desarrollado con **Terraform**, **AWS**, **Google Cloud** y **Docker Compose**.

El objetivo fue provisionar infraestructura en dos proveedores cloud y desplegar una aplicación organizada en microservicios, incorporando almacenamiento de objetos y un flujo de respaldos entre nubes.

> **Estado:** proyecto académico finalizado. La infraestructura desplegada durante el desarrollo fue dada de baja; este repositorio conserva el código como muestra del trabajo realizado. No existe actualmente un entorno productivo disponible.

## Arquitectura y componentes

### Infraestructura como código
Terraform define y aprovisiona los recursos principales:

- **AWS:** red virtual (VPC), subredes, gateway de Internet y tablas de rutas.
- **Cómputo:** instancias EC2 para la aplicación y tareas de administración/respaldo.
- **Base de datos:** instancia PostgreSQL administrada mediante Amazon RDS.
- **Almacenamiento:** volúmenes EBS, snapshots y buckets S3.
- **Google Cloud:** bucket de Cloud Storage como destino secundario de respaldos.

### Aplicación
La aplicación se organiza en servicios desplegados mediante Docker Compose:

- Frontend web.
- Servicio de usuarios.
- Servicio de catálogo.
- Servicio de contenidos.
- Nginx como componente de proxy dentro de la estructura del proyecto.

### Automatización y respaldos
- Scripts Bash y PowerShell para generar la configuración de entorno.
- Script de respaldo que comprime los datos y los copia a Amazon S3 y Google Cloud Storage.
- Script de inicialización de instancia para instalar Docker, AWS CLI y Google Cloud CLI.

## Tecnologías

- Terraform
- Amazon Web Services (EC2, VPC, RDS, S3, EBS)
- Google Cloud Platform (Cloud Storage)
- Docker y Docker Compose
- PostgreSQL
- Bash y PowerShell
- Nginx

## Estructura del repositorio

```text
.
├── *.tf                         # Definición de infraestructura Terraform
├── terraform.tfvars.example     # Plantilla de variables de Terraform
├── user_data.sh                 # Inicialización de instancias
├── backup-to-gcp.sh             # Respaldo hacia AWS S3 y Google Cloud Storage
├── generate_env.sh              # Generación de variables de entorno (Linux)
├── generate_env.ps1             # Generación de variables de entorno (Windows)
├── deploy_instructions/         # Material e instrucciones de despliegue
└── proyecto-docker-ti/
    ├── docker-compose.yml
    ├── frontend-service/
    ├── users-service/
    ├── catalogo-service/
    ├── content-service/
    └── nginx/
```

## Configuración

### Requisitos

Para reproducir el despliegue se requiere, como mínimo:

- Terraform 1.5 o superior.
- AWS CLI y credenciales con permisos para crear los recursos definidos.
- Google Cloud CLI y un proyecto de Google Cloud habilitado.
- Una clave SSH (par de clave pública y privada).
- Docker y Docker Compose para ejecutar la aplicación.

El despliegue puede generar costos en AWS y Google Cloud. Revisar los recursos y precios de cada proveedor antes de ejecutarlo.

### Variables de Terraform

1. Clonar el repositorio.
2. Crear el archivo local de variables a partir de la plantilla:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

   En PowerShell:

   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```

3. Completar en `terraform.tfvars` el ID del proyecto de Google Cloud, la IP pública autorizada y las rutas locales de las claves.
4. Ubicar el archivo JSON de credenciales de Google Cloud en la ruta configurada. El directorio `keys/` está excluido de Git.

### Despliegue de infraestructura

Desde el directorio raíz:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform solicitará confirmación antes de crear los recursos. Para eliminarlos mediante Terraform:

```bash
terraform destroy
```

No ejecutar estos comandos sin revisar previamente la cuenta, el workspace y el plan correspondiente.

### Aplicación y respaldos

La definición de los contenedores se encuentra en `proyecto-docker-ti/docker-compose.yml`. Los scripts de generación de entorno y respaldo contienen rutas y supuestos propios del entorno original, por lo que deben revisarse y adaptarse antes de utilizarlos en otra infraestructura.

Los marcadores `REPLACE_WITH_DB_PASSWORD` presentes en la configuración deben sustituirse por una contraseña propia antes de cualquier despliegue. No almacenar contraseñas, claves privadas ni archivos de credenciales en el repositorio.

## Consideraciones

- Los archivos `terraform.tfvars`, estados de Terraform, credenciales, claves y archivos `.env` locales están excluidos mediante `.gitignore`.
- `terraform.tfvars.example` contiene únicamente valores de ejemplo; no incluye credenciales reales.
- El código se conserva con fines académicos y de portafolio. Puede requerir ajustes para ejecutarse en cuentas y entornos actuales.
