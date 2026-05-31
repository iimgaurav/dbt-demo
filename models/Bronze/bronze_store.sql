select
    store_sk,
    store_code,
    store_name,
    city,
    state_province,
    region,
    country,
    open_date,
    sq_ft,
    'bronze' as record_source,
    current_timestamp() as load_date
from {{ source('source', 'store') }}
