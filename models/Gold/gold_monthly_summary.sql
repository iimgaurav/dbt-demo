select
    d.year,
    d.month,
    d.month_name,
    d.quarter,
    count(distinct s.sales_id) as total_transactions,
    count(distinct s.customer_sk) as active_customers,
    count(distinct s.product_sk) as products_sold,
    count(distinct s.store_sk) as active_stores,
    sum(s.quantity) as total_units_sold,
    round(sum(s.net_amount), 2) as total_revenue,
    round(avg(s.net_amount), 2) as avg_transaction_value,
    count(distinct r.sales_id) as total_returns,
    round(coalesce(sum(r.refund_amount), 0), 2) as total_refunds,
    round(
        coalesce(sum(r.refund_amount), 0) / nullif(sum(s.net_amount), 0) * 100, 2
    ) as return_rate_pct,
    current_timestamp as computed_at
from {{ ref('silver_date') }} d
left join {{ ref('silver_sales') }} s on d.date_sk = s.date_sk
left join {{ ref('silver_returns') }} r on d.date_sk = r.date_sk
group by
    d.year, d.month, d.month_name, d.quarter
