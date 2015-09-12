#!/bin/bash
_now=$(date +%y-%m-%d)
_file="db_backup_$_now.sql"

echo "Starting backup to $_file on $HOSTNAME"
pg_dump -h$HOSTNAME -p32769 -Upostgres postgres > "$_file"

echo "Compressing $_file before upload"
gzip -9 -f "$_file"

echo "Uploading $_file.gz to S3"
aws --region eu-west-1 s3 cp "$_file.gz" s3://impymoneybackup/
echo "Upload done"
