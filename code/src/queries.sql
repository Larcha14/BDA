SELECT store_COUNTry, COUNT (store_COUNTry) AS cnt FROM base_sales_data
GROUP BY store_COUNTry;

SELECT store_city, COUNT (store_city) AS cnt FROM base_sales_data
GROUP BY store_city
ORDER BY cnt DESC;

SELECT product_size, COUNT (product_size) AS cnt FROM base_sales_data
GROUP BY product_size
ORDER BY cnt DESC;

SELECT product_brand, COUNT (product_brand) AS cnt FROM base_sales_data
GROUP BY product_brand
ORDER BY cnt DESC;

SELECT product_material, COUNT (product_material) AS cnt FROM base_sales_data
GROUP BY product_material
ORDER BY cnt DESC;

SELECT product_category, COUNT (product_category) AS cnt FROM base_sales_data
GROUP BY product_category
ORDER BY cnt DESC;

SELECT sale_date, COUNT (sale_date) AS cnt FROM base_sales_data
GROUP BY sale_date
ORDER BY cnt DESC;

SELECT store_location, COUNT (store_location) AS cnt FROM base_sales_data
GROUP BY store_location
ORDER BY cnt DESC;


SELECT customer_email
FROM base_sales_data
WHERE customer_email = seller_email
  AND customer_email IS NOT NULL
  AND trim(customer_email) <> ''
GROUP BY customer_email
HAVING COUNT(*) > 0;

SELECT customer_email, COUNT(*) AS email_COUNT
FROM base_sales_data
WHERE customer_email IS NOT NULL
  AND trim(customer_email) <> ''
GROUP BY customer_email
HAVING COUNT(*) > 1
ORDER BY email_COUNT DESC;

WITH all_dates AS (
    SELECT product_expiry_date AS date FROM base_sales_data
    WHERE product_expiry_date IS NOT NULL
    UNION ALL
    SELECT product_release_date FROM base_sales_data
    WHERE product_release_date IS NOT NULL
    UNION ALL
    SELECT sale_date FROM base_sales_data
    WHERE sale_date IS NOT NULL
)

SELECT date, COUNT(*) AS occurrences
FROM all_dates
GROUP BY date
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, date;

SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(original_id) AS null_original_id,
  COUNT(*) - COUNT(customer_first_name) AS null_customer_first_name,
  COUNT(*) - COUNT(customer_last_name) AS null_customer_last_name,
  COUNT(*) - COUNT(customer_age) AS null_customer_age,
  COUNT(*) - COUNT(customer_email) AS null_customer_email,
  COUNT(*) - COUNT(customer_COUNTry) AS null_customer_COUNTry,
  COUNT(*) - COUNT(customer_postal_code) AS null_customer_postal_code,
  COUNT(*) - COUNT(customer_pet_type) AS null_customer_pet_type,
  COUNT(*) - COUNT(customer_pet_name) AS null_customer_pet_name,
  COUNT(*) - COUNT(customer_pet_breed) AS null_customer_pet_breed,
  COUNT(*) - COUNT(seller_first_name) AS null_seller_first_name,
  COUNT(*) - COUNT(seller_last_name) AS null_seller_last_name,
  COUNT(*) - COUNT(seller_email) AS null_seller_email,
  COUNT(*) - COUNT(seller_COUNTry) AS null_seller_COUNTry,
  COUNT(*) - COUNT(seller_postal_code) AS null_seller_postal_code,
  COUNT(*) - COUNT(product_name) AS null_product_name,
  COUNT(*) - COUNT(product_category) AS null_product_category,
  COUNT(*) - COUNT(product_price) AS null_product_price,
  COUNT(*) - COUNT(product_quantity) AS null_product_quantity,
  COUNT(*) - COUNT(sale_date) AS null_sale_date,
  COUNT(*) - COUNT(sale_customer_id) AS null_sale_customer_id,
  COUNT(*) - COUNT(sale_seller_id) AS null_sale_seller_id,
  COUNT(*) - COUNT(sale_product_id) AS null_sale_product_id,
  COUNT(*) - COUNT(sale_quantity) AS null_sale_quantity,
  COUNT(*) - COUNT(sale_total_price) AS null_sale_total_price,
  COUNT(*) - COUNT(store_name) AS null_store_name,
  COUNT(*) - COUNT(store_location) AS null_store_location,
  COUNT(*) - COUNT(store_city) AS null_store_city,
  COUNT(*) - COUNT(store_state) AS null_store_state,
  COUNT(*) - COUNT(store_COUNTry) AS null_store_COUNTry,
  COUNT(*) - COUNT(store_phone) AS null_store_phone,
  COUNT(*) - COUNT(store_email) AS null_store_email,
  COUNT(*) - COUNT(pet_category) AS null_pet_category,
  COUNT(*) - COUNT(product_weight) AS null_product_weight,
  COUNT(*) - COUNT(product_color) AS null_product_color,
  COUNT(*) - COUNT(product_size) AS null_product_size,
  COUNT(*) - COUNT(product_brand) AS null_product_brand,
  COUNT(*) - COUNT(product_material) AS null_product_material,
  COUNT(*) - COUNT(product_DESCription) AS null_product_DESCription,
  COUNT(*) - COUNT(product_rating) AS null_product_rating,
  COUNT(*) - COUNT(product_reviews) AS null_product_reviews,
  COUNT(*) - COUNT(product_release_date) AS null_product_release_date,
  COUNT(*) - COUNT(product_expiry_date) AS null_product_expiry_date,
  COUNT(*) - COUNT(supplier_name) AS null_supplier_name,
  COUNT(*) - COUNT(supplier_contact) AS null_supplier_contact,
  COUNT(*) - COUNT(supplier_email) AS null_supplier_email,
  COUNT(*) - COUNT(supplier_phone) AS null_supplier_phone,
  COUNT(*) - COUNT(supplier_address) AS null_supplier_address,
  COUNT(*) - COUNT(supplier_city) AS null_supplier_city,
  COUNT(*) - COUNT(supplier_COUNTry) AS null_supplier_COUNTry
FROM base_sales_data;
