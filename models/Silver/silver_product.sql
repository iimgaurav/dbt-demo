select
    product_sk,
    product_code,
    product_name,
    department,
    category,
    supplier_sk,
    list_price,
    uom,
    current_timestamp as ingested_at
from {{ ref('bronze_product') }}
where product_sk is not null
