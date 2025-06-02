#!/bin/bash

set -e

echo "Поднимаю контейнер с PostgreSQL..."
docker-compose up -d

echo "Выдача разрешения на исполнение скриптов..."
chmod +x ./src/insert_values_base.sh
chmod +x ./src/load_snowflake.sh

echo "Загрузка  MOCK_DATA*.csv в base_sales_data..."
./src/insert_values_base.sh

echo "Заполнение снежинки из base_sales_data..."
./src/load_snowflake.sh

echo "Завершение..."