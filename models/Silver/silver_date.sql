{{
  config(
    materialized = 'table'
  )
}}

SELECT
    date_sk,
    date,
    day,
    month,
    month_name,
    quarter,
    year,
    day_of_week,
    day_name,
    is_weekend,
    is_month_end,
    is_month_start,
    is_quarter_end,
    is_quarter_start,
    current_timestamp AS ingested_at
from {{ ref('bronze_date') }}
where date_sk is not null
