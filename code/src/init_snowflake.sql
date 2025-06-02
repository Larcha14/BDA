CREATE TABLE IF NOT EXISTS dim_country (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_city (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_postal_code (
    id SERIAL PRIMARY KEY,
    code TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_product_brand (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS dim_product_material (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS dim_product_category (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS dim_product_size (
    id SERIAL PRIMARY KEY,
    size TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS dim_pet_category (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS dim_pet_breed (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS dim_pet (
    id SERIAL PRIMARY KEY,
    name TEXT,
    category_id INTEGER REFERENCES dim_pet_category(id),
    breed_id INTEGER REFERENCES dim_pet_breed(id)
);


CREATE TABLE IF NOT EXISTS dim_customer (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    age INTEGER,
    email TEXT,
    country_id INTEGER REFERENCES dim_country(id),
    postal_code_id INTEGER REFERENCES dim_postal_code(id),
    pet_id INTEGER REFERENCES dim_pet(id)
);


CREATE TABLE IF NOT EXISTS dim_seller (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    country_id INTEGER REFERENCES dim_country(id),
    postal_code_id INTEGER REFERENCES dim_postal_code(id)
);


CREATE TABLE IF NOT EXISTS dim_product (
    id SERIAL PRIMARY KEY,
    name TEXT,
    category_id INTEGER REFERENCES dim_product_category(id),
    price NUMERIC(10,2),
    weight NUMERIC(10,3),
    size_id INTEGER REFERENCES dim_product_size(id),
    brand_id INTEGER REFERENCES dim_product_brand(id),
    material_id INTEGER REFERENCES dim_product_material(id),
    color TEXT,
    description TEXT,
    rating NUMERIC(12,2),
    reviews INTEGER,
    release_date_id INTEGER REFERENCES dim_date(id),
    expiry_date_id INTEGER REFERENCES dim_date(id)
);


CREATE TABLE IF NOT EXISTS dim_store (
    id SERIAL PRIMARY KEY,
    name TEXT,
    location TEXT,
    city_id INTEGER REFERENCES dim_city(id),
    state TEXT,
    country_id INTEGER REFERENCES dim_country(id),
    phone TEXT,
    email TEXT
);


CREATE TABLE IF NOT EXISTS dim_supplier (
    id SERIAL PRIMARY KEY,
    name TEXT,
    contact TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    city_id INTEGER REFERENCES dim_city(id),
    country_id INTEGER REFERENCES dim_country(id)
);



CREATE TABLE IF NOT EXISTS dim_date (
    id SERIAL PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name TEXT,
    day INTEGER,
    weekday INTEGER,
    weekday_name TEXT,
    is_weekend BOOLEAN
);

DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales (
    id SERIAL PRIMARY KEY,
    original_id INTEGER,
    date_id INTEGER REFERENCES dim_date(id),
    quantity INTEGER,
    total_price NUMERIC(12,2),

    customer_id INTEGER REFERENCES dim_customer(id),
    seller_id INTEGER REFERENCES dim_seller(id),
    product_id INTEGER REFERENCES dim_product(id),
    store_id INTEGER REFERENCES dim_store(id),
    supplier_id INTEGER REFERENCES dim_supplier(id)
);