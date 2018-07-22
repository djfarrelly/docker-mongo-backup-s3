FROM mongo:3.6

RUN apt-get update && \
    apt-get install -y curl zip
ADD backup.sh backup.sh

CMD ["./backup.sh"]
