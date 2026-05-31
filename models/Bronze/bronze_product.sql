select
    product_sk,
    product_code,
    product_name,
    department,
    category,
    supplier_sk,
    list_price,
    uom,
    'bronze' as record_source,
    current_timestamp() as load_date
from {{ source('source', 'product') }}
