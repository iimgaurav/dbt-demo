{% macro safe_divide(numerator, denominator, places=2) %}
  ROUND({{ numerator }} / NULLIF({{ denominator }}, 0), {{ places }})
{% endmacro %}
