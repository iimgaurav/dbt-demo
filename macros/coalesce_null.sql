{% macro coalesce_null(column, default) %}
  COALESCE({{ column }}, {{ default }})
{% endmacro %}
