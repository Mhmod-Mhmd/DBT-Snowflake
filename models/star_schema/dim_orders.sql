select 
order_date,
order_status
from {{ ref('stg_orders')}}