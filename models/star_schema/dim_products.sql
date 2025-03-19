select 
product_name,
product_category
from {{ref('stg_products')}}