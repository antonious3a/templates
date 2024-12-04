#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="27018"
BACKUP_DIR="/backups/mongodb"
RESTORE_DIR=""

if [ -z "$MONGO_USER" ] || [ -z "$MONGO_PASSWORD" ]; then
  echo "Error: environment variables MONGO_USER & MONGO_PASSWORD are not set"
  exit 1
fi

echo "Available backups:"
ls -1 "$BACKUP_DIR"
echo

read -r -p "Enter the folder name of the backup to restore (e.g., 20240101_123456): " RESTORE_DIR

RESTORE_PATH="$BACKUP_DIR/$RESTORE_DIR"

if [ ! -d "$RESTORE_PATH" ]; then
  echo "Error: Backup folder $RESTORE_PATH does not exist"
  exit 1
fi

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
START_TIMESTAMP=$(date +%s)
echo "Restoration started at $START_TIME"

echo "Restoring databases from $RESTORE_PATH"

for DB_PATH in "$RESTORE_PATH"/*; do
  DB_NAME=$(basename "$DB_PATH")

  echo "Restoring database: $DB_NAME"

  if mongorestore --host $REMOTE_HOST --port $REMOTE_PORT -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase admin --drop --gzip --nsInclude "$DB_NAME.*" "$RESTORE_PATH"; then
    echo "Database $DB_NAME restored successfully."
  else
    echo "Error restoring database $DB_NAME."
  fi
done

END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
END_TIMESTAMP=$(date +%s)
DURATION=$((END_TIMESTAMP - START_TIMESTAMP))

echo "Restoration finished at $END_TIME"

HOURS=$((DURATION / 3600))
MINUTES=$((DURATION % 3600 / 60))
SECONDS=$((DURATION % 60))

echo "Total time taken: $HOURS hours, $MINUTES minutes, and $SECONDS seconds."

echo "Restore script executed."
