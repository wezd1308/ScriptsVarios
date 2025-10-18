#!/bin/bash
#
# Script: backup_to_azure.sh
# Descripción: Comprime los backups y los sube a Azure Blob Storage.
# Autor: Walter Zambrano

# === Configuración ===
BACKUP_DIR="/backups"
LOG_FILE="/var/log/azure_backup.log"
ACCOUNT_NAME="sawezd"
CONTAINER_NAME="backuplnx"
CONN_FILE="/root/.azure_blob_conn"

# === Funciones auxiliares ===
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

# === Verificaciones previas ===
if [ ! -f "$CONN_FILE" ]; then
    log "ERROR: No se encuentra el archivo de conexión: $CONN_FILE"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    log "ERROR: No existe el directorio de backups: $BACKUP_DIR"
    exit 1
fi

# === Crear backup (opcional si ya existe el .tar.gz) ===
# Puedes descomentar esta línea si querés crear el tar directamente aquí:
# tar -czf "$BACKUP_DIR/home_$(date +%Y%m%d).tar.gz" /home 2>>"$LOG_FILE"

# === Subir a Azure ===
log "Inicio de carga a Azure Blob Storage..."
/usr/bin/az storage blob upload-batch \
    --account-name "$ACCOUNT_NAME" \
    --destination "$CONTAINER_NAME" \
    --source "$BACKUP_DIR" \
    --pattern "*.tar.gz" \
    --connection-string "$(cat "$CONN_FILE")" \
    >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "Carga completada correctamente."
else
    log "ERROR durante la carga a Azure Blob Storage."
fi

log "---------------------------------------------------"
