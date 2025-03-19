select 
customer_id,
customer_name, 
country,
email
from {{ref('stg_customer')}}