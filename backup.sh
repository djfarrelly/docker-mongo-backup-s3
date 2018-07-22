#!/bin/bash

if [[ -v CRONHUB_KEY ]]; then
  curl -fsS --retry 3 https://cronhub.io/start/$CRONHUB_KEY
fi

# Requires these environment variables to be set:
# DB_URL
# DB_USER
# DB_PASSWORD
# DB
# S3_BUCKET
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

DUMP_DIR="./dump"

# Ensure there is no old backup
rm -rf $DUMP_DIR

echo "Starting backup..."
mongodump \
  -h $DB_URL \
  -u $DB_USER \
  -p $DB_PASSWORD \
  --ssl \
  --authenticationDatabase admin \
  -d $DB

echo "Backup complete."
echo "Compressing backup..."

fileName=`date +%Y-%m-%d-%H%M%S.zip`
zip -r $fileName $DUMP_DIR

echo "Compression complete"

echo "Uploading backup to s3..."

dateFormatted=`date -R`

relativePath="/${S3_BUCKET}/${fileName}"
contentType="application/octet-stream"
stringToSign="PUT\n\n${contentType}\n${dateFormatted}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${AWS_SECRET_ACCESS_KEY} -binary | base64`
curl -X PUT -T "${fileName}" \
  -H "Host: ${S3_BUCKET}.s3.amazonaws.com" \
  -H "Date: ${dateFormatted}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${AWS_ACCESS_KEY_ID}:${signature}" \
  http://${S3_BUCKET}.s3.amazonaws.com/${fileName}

echo "Upload complete."

echo "Cleaning up..."
rm -rf $DUMP_DIR
rm $fileName

echo "Database backup successful at $dateFormatted"

if [[ -v CRONHUB_KEY ]]; then
  curl -fsS --retry 3 https://cronhub.io/finish/$CRONHUB_KEY
fi
