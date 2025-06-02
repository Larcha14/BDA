INSERT INTO dim_country(name)
SELECT DISTINCT c
FROM base_sales_data b,
LATERAL unnest(ARRAY[
    b.store_country,
    b.supplier_country,
    b.customer_country,
    b.seller_country
]) AS c
WHERE c IS NOT NULL AND TRIM(c) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_city(name)
SELECT DISTINCT c
FROM base_sales_data b,
LATERAL unnest(ARRAY[
    b.store_city,
    b.supplier_city
]) AS c
WHERE c IS NOT NULL AND TRIM(c) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_postal_code(code)
SELECT DISTINCT c
FROM base_sales_data b,
LATERAL unnest(ARRAY[
    b.customer_postal_code,
    b.seller_postal_code
]) AS c
WHERE c IS NOT NULL AND TRIM(c) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_product_brand(name)
SELECT DISTINCT product_brand
FROM base_sales_data
WHERE product_brand IS NOT NULL AND TRIM(product_brand) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_product_material(name)
SELECT DISTINCT product_material
FROM base_sales_data
WHERE product_material IS NOT NULL AND TRIM(product_material) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_product_category(name)
SELECT DISTINCT product_category
FROM base_sales_data
WHERE product_category IS NOT NULL AND TRIM(product_category) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_product_size(size)
SELECT DISTINCT product_size
FROM base_sales_data
WHERE product_size IS NOT NULL AND TRIM(product_size) <> ''
ON CONFLICT DO NOTHING;

INSERT INTO dim_pet_category(name)
SELECT DISTINCT pet_category
FROM base_sales_data
WHERE pet_category IS NOT NULL AND TRIM(pet_category) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_pet_breed(name)
SELECT DISTINCT customer_pet_breed
FROM base_sales_data
WHERE customer_pet_breed IS NOT NULL AND TRIM(customer_pet_breed) <> ''
ON CONFLICT DO NOTHING;


INSERT INTO dim_pet(name, category_id, breed_id)
SELECT DISTINCT
    customer_pet_name,
    (SELECT id FROM dim_pet_category WHERE name = pet_category),
    (SELECT id FROM dim_pet_breed WHERE name = customer_pet_breed)
FROM base_sales_data
WHERE customer_pet_name IS NOT NULL
ON CONFLICT DO NOTHING;



INSERT INTO dim_customer(first_name, last_name, age, email, country_id, postal_code_id, pet_id)
SELECT DISTINCT
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    (SELECT id FROM dim_country WHERE name = customer_country),
    (SELECT id FROM dim_postal_code WHERE code = customer_postal_code),
    (SELECT id FROM dim_pet WHERE name = customer_pet_name)
FROM base_sales_data
ON CONFLICT DO NOTHING;


INSERT INTO dim_seller(first_name, last_name, email, country_id, postal_code_id)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    (SELECT id FROM dim_country WHERE name = seller_country),
    (SELECT id FROM dim_postal_code WHERE code = seller_postal_code)
FROM base_sales_data
ON CONFLICT DO NOTHING;


INSERT INTO dim_store(name, location, city_id, state, country_id, phone, email)
SELECT DISTINCT
    store_name,
    store_location,
    (SELECT id FROM dim_city WHERE name = store_city),
    store_state,
    (SELECT id FROM dim_country WHERE name = store_country),
    store_phone,
    store_email
FROM base_sales_data
ON CONFLICT DO NOTHING;


INSERT INTO dim_supplier(name, contact, email, phone, address, city_id, country_id)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    (SELECT id FROM dim_city WHERE name = supplier_city),
    (SELECT id FROM dim_country WHERE name = supplier_country)
FROM base_sales_data
ON CONFLICT DO NOTHING;


INSERT INTO dim_date(date, year, quarter, month, month_name, day, weekday, weekday_name, is_weekend)
SELECT DISTINCT
    d,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(QUARTER FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    TO_CHAR(d, 'Month'),
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(DOW FROM d)::INT,
    TO_CHAR(d, 'Day'),
    CASE WHEN EXTRACT(DOW FROM d) IN (0,6) THEN TRUE ELSE FALSE END
FROM (
    SELECT sale_date AS d FROM base_sales_data
    UNION
    SELECT product_release_date FROM base_sales_data
    UNION
    SELECT product_expiry_date FROM base_sales_data
) AS dates
WHERE d IS NOT NULL
ON CONFLICT DO NOTHING;


INSERT INTO dim_product(
    name, category_id, price, weight, size_id, brand_id,
    material_id, color, description, rating, reviews,
    release_date_id, expiry_date_id
)
SELECT DISTINCT
    product_name,
    (SELECT id FROM dim_product_category WHERE name = product_category),
    product_price,
    product_weight,
    (SELECT id FROM dim_product_size WHERE size = product_size),
    (SELECT id FROM dim_product_brand WHERE name = product_brand),
    (SELECT id FROM dim_product_material WHERE name = product_material),
    product_color,
    product_description,
    product_rating,
    product_reviews,
    (SELECT id FROM dim_date WHERE date = product_release_date),
    (SELECT id FROM dim_date WHERE date = product_expiry_date)
FROM base_sales_data
ON CONFLICT DO NOTHING;

INSERT INTO fact_sales(
    original_id, date_id, quantity, total_price,
    customer_id, seller_id, product_id, store_id, supplier_id
)
SELECT
    original_id,
    (SELECT id FROM dim_date WHERE date = sale_date),
    sale_quantity,
    sale_total_price,
    (SELECT id FROM dim_customer WHERE email = customer_email),
    (SELECT id FROM dim_seller WHERE email = seller_email),
    (SELECT id FROM dim_product WHERE name = product_name AND price = product_price),
    (SELECT id FROM dim_store WHERE name = store_name),
    (SELECT id FROM dim_supplier WHERE name = supplier_name)
FROM base_sales_data;