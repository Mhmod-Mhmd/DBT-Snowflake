select
id AS product_id,
name AS product_name,
category AS product_category,
price AS product_price
from {{ source('raw_data', 'products')}}