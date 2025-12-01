FROM flyway/flyway:10-alpine

COPY sql /flyway/sql
COPY flyway.conf /flyway/conf/flyway.conf

ENTRYPOINT ["flyway", "migrate"]

