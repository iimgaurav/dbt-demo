{% macro standardize_text(column) %}
  LOWER(TRIM({{ column }}))
{% endmacro %}
