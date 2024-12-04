#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="5433"
BACKUP_DIR="/backups/postgresql"

if [ -z "$PG_USER" ] || [ -z "$PG_PASSWORD" ]; then
  echo "Error: environment variables PG_USER & PG_PASSWORD are not set"
  exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: backup directory $BACKUP_DIR does not exist."
  exit 1
fi

echo "Starting database restoration..."

for DB_BACKUP_DIR in "$BACKUP_DIR"/*; do
  if [ -d "$DB_BACKUP_DIR" ]; then
    DB=$(basename "$DB_BACKUP_DIR")
    LATEST_BACKUP=$(ls -t "$DB_BACKUP_DIR"/*.sql | head -n 1)

    if [ -z "$LATEST_BACKUP" ]; then
      echo "Warning: No backup file found for database $DB."
      continue
    fi

    echo "Restoring database: $DB"

    DB_EXISTS=$(PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB';")

    if [ "$DB_EXISTS" == "1" ]; then
      echo "Database $DB exists. Dropping it..."
      PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -c "DROP DATABASE \"$DB\";"
      if [ $? -ne 0 ]; then
        echo "Error: Failed to drop database $DB."
        continue
      fi
    fi

    echo "Creating database $DB..."
    PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -c "CREATE DATABASE \"$DB\";"
    if [ $? -ne 0 ]; then
      echo "Error: Failed to create database $DB."
      continue
    fi

    PGPASSWORD=$PG_PASSWORD pg_restore -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -d "$DB" "$LATEST_BACKUP"

    if [ $? -eq 0 ]; then
      echo "Database $DB restored successfully!"
    else
      echo "Error restoring database $DB from $LATEST_BACKUP."
    fi
  fi
done

echo "Database restoration completed."