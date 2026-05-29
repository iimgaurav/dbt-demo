select sales_id, net_amount
from {{ ref('silver_sales') }}
where net_amount < 0
