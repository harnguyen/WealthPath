#!/bin/bash
# WealthPath Database Backup Script
# Creates a PostgreSQL backup from the AWS server
#
# Usage: ./scripts/backup-db.sh [output_dir]
# Example: ./scripts/backup-db.sh ~/backups

set -e

# Configuration
SERVER_IP="${SERVER_IP:-52.220.155.187}"
SSH_KEY="${SSH_KEY:-~/.ssh/wealthpath_key}"
SSH_USER="${SSH_USER:-ubuntu}"
DB_CONTAINER="${DB_CONTAINER:-wealthpath-postgres-1}"
DB_USER="${DB_USER:-wealthpath}"
DB_NAME="${DB_NAME:-wealthpath}"

# Output directory (default: current directory)
OUTPUT_DIR="${1:-.}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${OUTPUT_DIR}/wealthpath_backup_${TIMESTAMP}.sql"
BACKUP_FILE_GZ="${BACKUP_FILE}.gz"

echo "🔧 WealthPath Database Backup"
echo "=============================="
echo "Server: ${SSH_USER}@${SERVER_IP}"
echo "Container: ${DB_CONTAINER}"
echo "Database: ${DB_NAME}"
echo ""

# Check SSH key exists
if [[ ! -f "${SSH_KEY/#\~/$HOME}" ]]; then
    echo "❌ SSH key not found: ${SSH_KEY}"
    echo "   Set SSH_KEY environment variable or check the path"
    exit 1
fi

# Create output directory if needed
mkdir -p "${OUTPUT_DIR}"

echo "📦 Creating backup..."

# Create the backup
ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no "${SSH_USER}@${SERVER_IP}" \
    "docker exec ${DB_CONTAINER} pg_dump -U ${DB_USER} -d ${DB_NAME} --clean --if-exists" \
    > "${BACKUP_FILE}"

# Check if backup was successful
if [[ ! -s "${BACKUP_FILE}" ]]; then
    echo "❌ Backup failed - file is empty"
    rm -f "${BACKUP_FILE}"
    exit 1
fi

# Get file size
BACKUP_SIZE=$(ls -lh "${BACKUP_FILE}" | awk '{print $5}')

echo "✅ Backup created: ${BACKUP_FILE} (${BACKUP_SIZE})"

# Compress the backup
echo "🗜️  Compressing backup..."
gzip -k "${BACKUP_FILE}"
COMPRESSED_SIZE=$(ls -lh "${BACKUP_FILE_GZ}" | awk '{print $5}')
echo "✅ Compressed: ${BACKUP_FILE_GZ} (${COMPRESSED_SIZE})"

echo ""
echo "=============================="
echo "✅ Backup complete!"
echo ""
echo "Files created:"
echo "  - ${BACKUP_FILE} (${BACKUP_SIZE})"
echo "  - ${BACKUP_FILE_GZ} (${COMPRESSED_SIZE})"
echo ""
echo "To restore later:"
echo "  gunzip -c ${BACKUP_FILE_GZ} | psql -U wealthpath -d wealthpath"
echo ""
echo "You can now safely shutdown the AWS server."

