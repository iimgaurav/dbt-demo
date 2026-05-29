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
    'bronze' as record_source,
    current_timestamp() as load_date
from {{ source('source', 'dim_customer') }}
