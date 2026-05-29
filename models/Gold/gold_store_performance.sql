select
    st.store_sk,
    st.store_code,
    st.store_name,
    st.city,
    st.state_province,
    st.region,
    st.country,
    st.store_age_group,
    count(distinct s.sales_id) as total_transactions,
    count(distinct s.customer_sk) as unique_customers,
    sum(s.quantity) as total_units_sold,
    round(sum(s.net_amount), 2) as total_revenue,
    round(avg(s.net_amount), 2) as avg_transaction_value,
    count(distinct r.sales_id) as total_returns,
    round(coalesce(sum(r.refund_amount), 0), 2) as total_refunds,
    round(
        coalesce(sum(r.refund_amount), 0) / nullif(sum(s.net_amount), 0) * 100, 2
    ) as return_rate_pct
from {{ ref('silver_store') }} st
left join {{ ref('silver_sales') }} s on st.store_sk = s.store_sk
left join {{ ref('silver_returns') }} r on st.store_sk = r.store_sk
group by
    st.store_sk, st.store_code, st.store_name, st.city,
    st.state_province, st.region, st.country, st.store_age_group
