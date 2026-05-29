select
    customer_sk,
    customer_code,
    first_name,
    last_name,
    gender,
    email,
    phone,
    loyalty_tier,
    signup_date,
    case
        when datediff(year, signup_date, current_date) < 1 then 'new'
        when datediff(year, signup_date, current_date) between 1 and 3 then 'regular'
        else 'loyal'
    end as customer_tenure,
    current_timestamp as ingested_at
from {{ ref('bronze_customer') }}
where customer_sk is not null
