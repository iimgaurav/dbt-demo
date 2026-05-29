{% macro describe_sources() %}
  {% set tables = [
    ('dbt_tutorial_dev', 'source', 'fact_sales'),
    ('dbt_tutorial_dev', 'source', 'dim_customer'),
    ('dbt_tutorial_dev', 'source', 'dim_product'),
    ('dbt_tutorial_dev', 'source', 'dim_date'),
    ('dbt_tutorial_dev', 'source', 'dim_store'),
    ('dbt_tutorial_dev', 'source', 'fact_returns')
  ] %}
  {% for db, schema, table in tables %}
    {{ log('=== ' ~ table ~ ' ===', info=True) }}
    {% set rel = api.Relation.create(database=db, schema=schema, identifier=table) %}
    {% set cols = adapter.get_columns_in_relation(rel) %}
    {% for col in cols %}
      {{ log('  ' ~ col.name ~ ' (' ~ col.dtype ~ ')', info=True) }}
    {% endfor %}
  {% endfor %}
{% endmacro %}
