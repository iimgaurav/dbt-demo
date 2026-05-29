select
    c.customer_sk,
    c.customer_code,
    c.first_name,
    c.last_name,
    c.email,
    c.loyalty_tier,
    c.customer_tenure,
    c.signup_date,
    count(distinct s.sales_id) as total_orders,
    sum(s.quantity) as total_units_purchased,
    round(sum(s.net_amount), 2) as total_spent,
    round(avg(s.net_amount), 2) as avg_order_value,
    round(sum(s.net_amount) / nullif(count(distinct s.sales_id), 0), 2) as revenue_per_order,
    current_timestamp as computed_at
from {{ ref('silver_customer') }} c
left join {{ ref('silver_sales') }} s on c.customer_sk = s.customer_sk
group by
    c.customer_sk, c.customer_code, c.first_name, c.last_name,
    c.email, c.loyalty_tier, c.customer_tenure, c.signup_date
