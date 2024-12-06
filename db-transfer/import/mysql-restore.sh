#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="3306"
BACKUP_DIR="/backups/mysql"
RESTORE_DIR=""

if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: environment variables MYSQL_USER & MYSQL_PASSWORD are not set"
  exit 1
fi

echo "Available backups:"
ls -1 "$BACKUP_DIR"
echo

read -r -p "Enter the folder name of the backup to restore (e.g., 20240101_123456): " RESTORE_DIR

RESTORE_PATH="$BACKUP_DIR/$RESTORE_DIR"

if [ ! -d "$RESTORE_PATH" ]; then
  echo "Error: Backup directory $RESTORE_PATH does not exist."
  exit 1
fi

cat <<EOF > ~/.mysql.cnf
[client]
user=$MYSQL_USER
password=$MYSQL_PASSWORD
host=$REMOTE_HOST
port=$REMOTE_PORT
EOF
chmod 600 ~/.mysql.cnf

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
START_TIMESTAMP=$(date +%s)
echo "Restoration started at $START_TIME"

echo "Restoring databases from $RESTORE_PATH..."
for DB_DIR in "$RESTORE_PATH"/*; do
  DB_NAME=$(basename "$DB_DIR")
  BACKUP_FILE="$DB_DIR/$DB_NAME.sql"

  if [ ! -f "$BACKUP_FILE" ]; then
    echo "Warning: Backup file for database $DB_NAME not found. Skipping..."
    continue
  fi

  echo "Restoring database: $DB_NAME"

  mysql --defaults-file=~/.mysql.cnf -e "DROP DATABASE IF EXISTS \`$DB_NAME\`;"
  mysql --defaults-file=~/.mysql.cnf -e "CREATE DATABASE \`$DB_NAME\`;"

  if mysql --defaults-file=~/.mysql.cnf "$DB_NAME" < "$BACKUP_FILE"; then
    echo "Restored database: $DB_NAME successfully."
  else
    echo "Error restoring database: $DB_NAME."
  fi
done

END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
END_TIMESTAMP=$(date +%s)
DURATION=$((END_TIMESTAMP - START_TIMESTAMP))

echo "Restoration finished at $END_TIME"
rm ~/.mysql.cnf

HOURS=$((DURATION / 3600))
MINUTES=$((DURATION % 3600 / 60))
SECONDS=$((DURATION % 60))

echo "Total time taken: $HOURS hours, $MINUTES minutes, and $SECONDS seconds."
echo "Database restoration completed."
