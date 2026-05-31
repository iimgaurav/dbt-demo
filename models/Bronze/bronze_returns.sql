select
    sales_id,
    date_sk,
    store_sk,
    product_sk,
    customer_sk,
    promotion_sk,
    returned_qty,
    return_reason,
    refund_amount,
    'bronze' as record_source,
    current_timestamp() as load_date
from {{ source('source', 'returns') }}
