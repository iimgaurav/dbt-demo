select
    sales_id,
    date_sk,
    store_sk,
    product_sk,
    customer_sk,
    promotion_sk,
    quantity,
    unit_price,
    gross_amount,
    discount_amount,
    net_amount,
    payment_method,
    'bronze' as record_source,
    current_timestamp() as load_date
from {{ source('source', 'sales') }}
