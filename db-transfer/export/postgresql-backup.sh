#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="5432"
BACKUP_DIR="/backups/postgresql"
DATE=$(date +"%Y%m%d_%H%M%S")

if [ -z "$PG_USER" ] || [ -z "$PG_PASSWORD" ]; then
  echo "Error: environment variables PG_USER & PG_PASSWORD are not set"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "Getting databases..."
DATABASES=$(PGPASSWORD=$PG_PASSWORD psql -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

if [ -z "$DATABASES" ]; then
  echo "Error: no databases found or error in connection"
  exit 1
fi

DBS_BACKUP_DIR="$BACKUP_DIR"/"$DATE"
mkdir -p "$DBS_BACKUP_DIR"

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
START_TIMESTAMP=$(date +%s)
echo "Backup started at $START_TIME"

echo "Starting backups..."
for DB in $DATABASES; do
  echo "Making backup of db: $DB"
  BACKUP_FILE="${DBS_BACKUP_DIR}/${DB}.sql"

  if PGPASSWORD=$PG_PASSWORD pg_dump -h $REMOTE_HOST -p $REMOTE_PORT -U "$PG_USER" -d "$DB" -F c -f "$BACKUP_FILE"; then
    echo "Backup of $DB completed successfully, file: $BACKUP_FILE"
  else
    echo "Error making backup of db $DB."
  fi
done

END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
END_TIMESTAMP=$(date +%s)
DURATION=$((END_TIMESTAMP - START_TIMESTAMP))

echo "Backups finished at $END_TIME"

BACKUPS_TO_DELETE=$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | sort | head -n -3)
if [ -n "$BACKUPS_TO_DELETE" ]; then
  echo "Deleting old backups"
  for DIR in $BACKUPS_TO_DELETE; do
    echo "Deleting $DIR"
    rm -r "$DIR"
  done
fi


HOURS=$((DURATION / 3600))
MINUTES=$((DURATION % 3600 / 60))
SECONDS=$((DURATION % 60))

echo "Total time taken: $HOURS hours, $MINUTES minutes, and $SECONDS seconds."
echo "Backup script executed."
