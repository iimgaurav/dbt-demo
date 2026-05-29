{% macro cap_outliers(column, cap) %}
  CASE
    WHEN {{ column }} > {{ cap }} THEN {{ cap }}
    ELSE {{ column }}
  END
{% endmacro %}
