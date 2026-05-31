select
    date_sk,
    date,
    year,
    month,
    month_name,
    day_of_week,
    quarter,
    is_weekend,
    'bronze' as record_source,
    current_timestamp() as load_date
from {{ source('source', 'date') }}
