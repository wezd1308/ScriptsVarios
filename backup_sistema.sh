#!/bin/bash
# Script para respaldar archivos
# Directorios a respaldar
SRC="/home/wzambrano"
DEST="/backups/$(date +%F)"
mkdir -p "$DEST"

# Crear backup comprimido
tar -czf "$DEST/sistema_backup_$(hostname)_$(date +%F).tar.gz" $SRC

# Borrar backups antiguos (más de 7 días)
find /backups/ -type d -mtime +7 -exec rm -rf {} \;
