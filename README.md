# docker-mongo-backup-s3

Docker image and script to create a mongo backup and upload to s3.

## Usage

Build the image:

```
docker build -t mongo-backup-s3 .
```

Run the backup:

```
docker run --rm \
  -e DB_URL="primary.mongo.net:27017,secondary.mongo.net:27017,backup.mongo.net:27017" \
  -e DB_USER="backup" \
  -e DB_PASSWORD="1234567890" \
  -e DB="myapp" \
  -e S3_BUCKET="myapp-db-backups" \
  -e AWS_ACCESS_KEY_ID="AKIAOIUKUI4TKJKJH2KD" \
  -e AWS_SECRET_ACCESS_KEY="..." \
  mongo-backup-s3
```

## License

MIT
