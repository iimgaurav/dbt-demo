{% macro list_models() %}
  {% set tables = [
    'bronze_customer', 'bronze_product', 'bronze_store', 'bronze_date',
    'bronze_sales', 'bronze_returns',
    'silver_customer', 'silver_product', 'silver_store', 'silver_sales', 'silver_returns',
    'gold_daily_sales', 'gold_store_performance', 'gold_product_performance',
    'gold_customer_metrics', 'gold_monthly_summary'
  ] %}
  {% for t in tables %}
    {% set rel = api.Relation.create(database='dbt_tutorial_dev', schema='default', identifier=t) %}
    {% set cols = adapter.get_columns_in_relation(rel) %}
    {{ log('=== ' ~ t ~ ' ===', info=True) }}
    {% for col in cols %}
      {{ log('  ' ~ col.name ~ ' (' ~ col.dtype ~ ')', info=True) }}
    {% endfor %}
  {% endfor %}
{% endmacro %}
