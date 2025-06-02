#!/bin/bash
set -e

DB_NAME="bd_abd_lab_1"
USER="server"
PASSWORD="password"
HOST="localhost"
DATA_PATH="../data"

COLUMNS="original_id,customer_first_name,customer_last_name,customer_age,customer_email,customer_country,customer_postal_code,customer_pet_type,customer_pet_name,customer_pet_breed,seller_first_name,seller_last_name,seller_email,seller_country,seller_postal_code,product_name,product_category,product_price,product_quantity,sale_date,sale_customer_id,sale_seller_id,sale_product_id,sale_quantity,sale_total_price,store_name,store_location,store_city,store_state,store_country,store_phone,store_email,pet_category,product_weight,product_color,product_size,product_brand,product_material,product_description,product_rating,product_reviews,product_release_date,product_expiry_date,supplier_name,supplier_contact,supplier_email,supplier_phone,supplier_address,supplier_city,supplier_country"

for file in "$DATA_PATH"/MOCK_DATA*.csv; do
  echo "Загружаю $file..."
  PGPASSWORD="$PASSWORD" psql -h $HOST -U $USER -d $DB_NAME \
    -c "\copy base_sales_data(original_id,customer_first_name,customer_last_name,customer_age,customer_email,customer_country,customer_postal_code,customer_pet_type,customer_pet_name,customer_pet_breed,seller_first_name,seller_last_name,seller_email,seller_country,seller_postal_code,product_name,product_category,product_price,product_quantity,sale_date,sale_customer_id,sale_seller_id,sale_product_id,sale_quantity,sale_total_price,store_name,store_location,store_city,store_state,store_country,store_phone,store_email,pet_category,product_weight,product_color,product_size,product_brand,product_material,product_description,product_rating,product_reviews,product_release_date,product_expiry_date,supplier_name,supplier_contact,supplier_email,supplier_phone,supplier_address,supplier_city,supplier_country) FROM '$file' DELIMITER ',' CSV HEADER;"
done

echo "Загрузка завершена"

echo "Загрузка данных в новую БД"
PGPASSWORD="$PASSWORD" psql -h $HOST -U $USER -d $DB_NAME -f /data/fill_snowflake_from_base.sql


exit 0
