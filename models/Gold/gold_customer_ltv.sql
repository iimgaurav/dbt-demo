{{
  config(
    materialized = 'incremental',
    unique_key = 'customer_sk'
  )
}}

select
    customer_sk,
    round(sum(net_amount), 2) as lifetime_value,
    current_timestamp as computed_at
from {{ ref('silver_sales') }}
where customer_sk is not null
group by customer_sk
