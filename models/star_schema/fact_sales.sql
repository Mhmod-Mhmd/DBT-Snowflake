

SELECT
    oi.unit_price AS unit_price,
    oi.quantity AS quantity,
    p.product_price AS product_price,
    oi.total_price AS total_price,
    oi.unit_price * oi.quantity AS sales_amount
FROM {{ ref('stg_order_items') }} AS oi
JOIN {{ ref('stg_orders') }} AS o ON oi.order_id = o.order_id
JOIN {{ ref('stg_products') }} AS p ON oi.product_id = p.product_id
