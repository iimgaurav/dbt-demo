{{
  config(
    materialized = 'table'
  )
}}

WITH cleaned_sales AS (
    SELECT
        sales_id,
        date_sk,
        store_sk,
        product_sk,
        customer_sk,
        {{ coalesce_null('promotion_sk', '-1') }} AS promotion_sk,

        {{ validate_positive('quantity') }} AS quantity,
        {{ validate_positive('unit_price') }} AS unit_price,
        {{ cap_outliers('gross_amount', '10000') }} AS gross_amount,

        discount_amount,
        net_amount,

        {{ standardize_text('payment_method') }} AS payment_method,

        {{ safe_divide('net_amount', 'quantity') }} AS effective_price,
        ROUND((discount_amount / NULLIF(gross_amount, 0)) * 100, 2) AS discount_percentage,

        {{ ingested_at() }}
    FROM {{ ref('bronze_sales') }}
    WHERE sales_id IS NOT NULL
)

SELECT
    sales_id,
    date_sk,
    store_sk,
    product_sk,
    customer_sk,
    promotion_sk,
    quantity,
    unit_price,
    round(gross_amount, 2) AS gross_amount,
    discount_amount,
    net_amount,
    payment_method,
    effective_price,
    discount_percentage,
    ingested_at
FROM cleaned_sales
WHERE quantity IS NOT NULL AND unit_price IS NOT NULL;
