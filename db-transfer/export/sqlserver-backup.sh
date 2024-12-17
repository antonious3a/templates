#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="1433"
BACKUP_DIR="/backups/sqlserver"
EXTRA_BACKUP_DIR="/backups/copy/sqlserver"
DATE=$(date +"%Y%m%d_%H%M%S")

if [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ]; then
  echo "Error: environment variables SQL_USER & SQL_PASSWORD are not set"
  exit 1
fi

mkdir -p "$BACKUP_DIR"
mkdir -p "$EXTRA_BACKUP_DIR"

echo "Getting databases..."
DATABASES=$(sqlcmd -S "$REMOTE_HOST,$REMOTE_PORT" -U "$SQL_USER" -P "$SQL_PASSWORD" -C -Q "SET NOCOUNT ON; SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');" -h -1 | grep -v '^$')

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
  DB_BACKUP_DIR="${DBS_BACKUP_DIR}/${DB}"
  mkdir -p "$DB_BACKUP_DIR"
  BACKUP_FILE="${DB_BACKUP_DIR}/${DB}.bak"



  if sqlcmd -S "$REMOTE_HOST,$REMOTE_PORT" -U "$SQL_USER" -P "$SQL_PASSWORD" -C -Q "BACKUP DATABASE [$DB] TO DISK = N'$BACKUP_FILE' WITH FORMAT, INIT, NAME = 'Full Backup of $DB';"; then
    echo "Backup of $DB completed successfully, file: $BACKUP_FILE"
  else
    echo "Error making backup of db $DB."
  fi
done

END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
END_TIMESTAMP=$(date +%s)
DURATION=$((END_TIMESTAMP - START_TIMESTAMP))

echo "Backups finished at $END_TIME"

cp -rp "$DBS_BACKUP_DIR" "$EXTRA_BACKUP_DIR"

delete_old_backups() {
  local DEL_BACKUP_DIR=$1
  BACKUPS_TO_DELETE=$(find "$DEL_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | sort | head -n -3)
  if [ -n "$BACKUPS_TO_DELETE" ]; then
    echo "Deleting old backups"
    for DIR in $BACKUPS_TO_DELETE; do
      echo "Deleting $DIR"
      rm -r "$DIR"
    done
  fi
}

delete_old_backups "$BACKUP_DIR"
delete_old_backups "$EXTRA_BACKUP_DIR"

HOURS=$((DURATION / 3600))
MINUTES=$((DURATION % 3600 / 60))
SECONDS=$((DURATION % 60))

echo "Total time taken: $HOURS hours, $MINUTES minutes, and $SECONDS seconds."
echo "Backup script executed."
