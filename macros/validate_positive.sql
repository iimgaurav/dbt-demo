{% macro validate_positive(column) %}
  CASE
    WHEN {{ column }} <= 0 THEN NULL
    ELSE {{ column }}
  END
{% endmacro %}
