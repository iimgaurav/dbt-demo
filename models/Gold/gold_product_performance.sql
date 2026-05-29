select
    p.product_sk,
    p.product_code,
    p.product_name,
    p.department,
    p.category,
    p.list_price,
    count(distinct s.sales_id) as total_transactions,
    sum(s.quantity) as total_units_sold,
    round(sum(s.net_amount), 2) as total_revenue,
    round(sum(s.net_amount) / nullif(sum(s.quantity), 0), 2) as avg_selling_price,
    count(distinct r.sales_id) as total_returns,
    coalesce(sum(r.returned_qty), 0) as total_returned_units,
    round(coalesce(sum(r.refund_amount), 0), 2) as total_refunds,
    round(
        coalesce(sum(r.returned_qty), 0) / nullif(sum(s.quantity), 0) * 100, 2
    ) as return_rate_pct
from {{ ref('silver_product') }} p
left join {{ ref('silver_sales') }} s on p.product_sk = s.product_sk
left join {{ ref('silver_returns') }} r on p.product_sk = r.product_sk
group by
    p.product_sk, p.product_code, p.product_name,
    p.department, p.category, p.list_price
