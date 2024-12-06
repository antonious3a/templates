#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="5433"
BACKUP_DIR="/backups/postgresql"
RESTORE_DIR=""

if [ -z "$PG_USER" ] || [ -z "$PG_PASSWORD" ]; then
  echo "Error: environment variables PG_USER & PG_PASSWORD are not set"
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

for DB_BACKUP_DIR in "$RESTORE_PATH"/*; do
  if [ -d "$DB_BACKUP_DIR" ]; then
    DB=$(basename "$DB_BACKUP_DIR")
    BACKUP_FILE="$DB_BACKUP_DIR/$DB.sql"

    if [ -z "$BACKUP_FILE" ]; then
      echo "Warning: No backup file found for database $DB."
      continue
    fi

    echo "Restoring database: $DB"

    DB_EXISTS=$(PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB';")

    if [ "$DB_EXISTS" == "1" ]; then
      echo "Database $DB exists. Dropping it..."

      if ! PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -c "DROP DATABASE \"$DB\";" ; then
        echo "Error: Failed to drop database $DB."
        continue
      fi
    fi

    echo "Creating database $DB..."

    if ! PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -c "CREATE DATABASE \"$DB\";" ; then
      echo "Error: Failed to create database $DB."
      continue
    fi

    if PGPASSWORD=$PG_PASSWORD pg_restore -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -d "$DB" "$BACKUP_FILE" ; then
      echo "Database $DB restored successfully!"
    else
      echo "Error restoring database $DB from $BACKUP_FILE."
    fi
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

echo "Database restoration completed."