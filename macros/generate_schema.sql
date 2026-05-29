{% macro generate_schema(name, schema) %}
  {{ return(schema or var('schema', target.schema)) }}
{% endmacro %}
