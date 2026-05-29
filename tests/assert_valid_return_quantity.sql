select sales_id, returned_qty
from {{ ref('silver_returns') }}
where returned_qty <= 0
