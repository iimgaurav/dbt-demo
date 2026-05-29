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
    case
        when open_date is null then 'unknown'
        when datediff(year, open_date, current_date) < 2 then 'new'
        else 'established'
    end as store_age_group,
    current_timestamp as ingested_at
from {{ ref('bronze_store') }}
where store_sk is not null
