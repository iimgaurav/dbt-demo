select
    store_sk,
    store_code,
    store_name,
    city,
    state_province,
    region,
    country,
    open_date,
    sq_ft
from {{ source('source', 'store') }}
