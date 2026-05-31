SELECT
    date_sk,
    date,
    year,
    month,
    month_name,
    day_of_week,
    quarter,
    is_weekend,
    current_timestamp AS ingested_at
from {{ ref('bronze_date') }}
where date_sk is not null
