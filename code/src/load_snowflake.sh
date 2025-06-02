#!/bin/bash
set -e

DB_NAME="bd_abd_lab_1"
USER="server"
PASSWORD="password"
HOST="localhost"

echo "Загружаем снежинку..."

PGPASSWORD="$PASSWORD" psql -h $HOST -U $USER -d $DB_NAME -f insert_snowflake.sql

echo "Загрузка завершена"
