{{
  config(
    materialized = 'table'
  )
}}

WITH sales_aggregated AS (
    SELECT
        s.date_sk,
        COUNT(DISTINCT s.sales_id) AS total_transactions,
        COUNT(DISTINCT s.customer_sk) AS unique_customers,
        SUM(s.quantity) AS total_units_sold,
        SUM(s.net_amount) AS total_revenue,
        ROUND(AVG(s.net_amount), 2) AS avg_transaction_value,
        ROUND(
            SUM(s.net_amount) / NULLIF(SUM(s.quantity), 0),
            2
        ) AS avg_unit_price_realized
    FROM {{ ref('silver_sales') }} s
    WHERE s.date_sk IS NOT NULL
    GROUP BY s.date_sk
)

SELECT
    d.date,
    d.year,
    d.quarter,
    d.month,
    d.month_name,
    d.day_of_week,
    sa.total_transactions,
    sa.unique_customers,
    sa.total_units_sold,
    ROUND(sa.total_revenue, 2) AS total_revenue,
    sa.avg_transaction_value,
    sa.avg_unit_price_realized,
    current_timestamp AS ingested_at
FROM sales_aggregated sa
INNER JOIN {{ ref('silver_date') }} d
    ON sa.date_sk = d.date_sk
ORDER BY d.date