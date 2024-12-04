#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="27017"
BACKUP_DIR="/backups/mongodb"
DATE=$(date +"%Y%m%d_%H%M%S")

if [ -z "$MONGO_USER" ] || [ -z "$MONGO_PASSWORD" ]; then
  echo "Error: environment variables MONGO_USER & MONGO_PASSWORD are not set"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "Getting databases..."
DATABASES=$(mongosh --host $REMOTE_HOST --port $REMOTE_PORT -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase admin --quiet --eval "db.adminCommand('listDatabases').databases.map(function(db) { return db.name; }).filter(function(name) { return ['admin', 'local', 'config'].indexOf(name) === -1; }).join(' ')")

if [ -z "$DATABASES" ]; then
  echo "Error: no databases found or error in connection"
  exit 1
fi

DB_BACKUP_DIR="$BACKUP_DIR"/"$DATE"
mkdir -p "$DB_BACKUP_DIR"

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
START_TIMESTAMP=$(date +%s)
echo "Backup started at $START_TIME"

echo "Starting backups..."
for DB in $DATABASES; do
  echo "Making backup of db: $DB"

  if mongodump --host $REMOTE_HOST --port $REMOTE_PORT -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase admin --db "$DB" --gzip --out "$DB_BACKUP_DIR"; then
    echo "Backup of $DB completed successfully, dir: $DB_BACKUP_DIR/$DB"
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
