#!/bin/bash

REMOTE_HOST="172.16.33.56"
REMOTE_PORT="3306"
BACKUP_DIR="/backups/mysql"
EXTRA_BACKUP_DIR="/backups/copy/mysql"
DATE=$(date +"%Y%m%d_%H%M%S")

if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: environment variables MYSQL_USER & MYSQL_PASSWORD are not set"
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

mkdir -p "$BACKUP_DIR"
mkdir -p "$EXTRA_BACKUP_DIR"

echo "Getting databases..."
DATABASES=$(mysql --defaults-file=~/.mysql.cnf -e "SHOW DATABASES;" | grep -Ev "^(Database|information_schema|performance_schema|mysql|sys)$")

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
  BACKUP_FILE="${DB_BACKUP_DIR}/${DB}.sql"

  if mysqldump  --defaults-file=~/.mysql.cnf "$DB" > "$BACKUP_FILE"; then
    echo "Backup of $DB completed successfully, file: $BACKUP_FILE"
  else
    echo "Error making backup of db $DB."
  fi
done

END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
END_TIMESTAMP=$(date +%s)
DURATION=$((END_TIMESTAMP - START_TIMESTAMP))

echo "Backups finished at $END_TIME"
rm ~/.mysql.cnf

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
