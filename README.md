# docker-mongo-backup-s3

Docker image and script to create a mongo backup and upload to S3.

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

Configuration variables:

* `DB_URL` - Replica set connection URL that will be passed to `mongodump`
* `DB_USER`, `DB_PASSWORD` - The user and password to authenticate with mongo
* `DB` - The name of the database of which to backup
* `S3_BUCKET` - The AWS S3 bucket to upload the backups to
* `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` - AWS Credentials w/ S3 PutObject
permission
* `CRONHUB_KEY` - A [Cronhub.io](https://cronhub.io) monitor key id

## License

MIT
