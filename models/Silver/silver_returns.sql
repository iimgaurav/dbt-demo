select
    sales_id,
    date_sk,
    store_sk,
    product_sk,
    customer_sk,
    returned_qty,
    return_reason,
    refund_amount,
    current_timestamp as ingested_at
from {{ ref('bronze_returns') }}
where sales_id is not null
  and returned_qty > 0
