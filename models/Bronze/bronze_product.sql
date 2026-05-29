select
    product_sk,
    product_code,
    product_name,
    department,
    category,
    supplier_sk,
    list_price,
    uom
from {{ source('source', 'dim_product') }}
