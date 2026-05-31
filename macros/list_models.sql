{% macro list_models() %}
    {# 
        Dynamically lists all models in the project with their columns.
        Usage: dbt run-operation list_models
    #}
    {% set models = graph.nodes.values() | selectattr('resource_type', 'equalto', 'model') | list %}
    
    {{ log("=== Project Models (" ~ models | length ~ " total) ===", info=True) }}
    
    {% for model in models | sort(attribute='name') %}
        {{ log("", info=True) }}
        {{ log("--- " ~ model.name ~ " (" ~ model.config.materialized ~ ") ---", info=True) }}
        {{ log("  Schema: " ~ model.schema, info=True) }}
        {{ log("  Description: " ~ (model.description | default('No description')), info=True) }}
        
        {% if model.columns %}
            {{ log("  Columns:", info=True) }}
            {% for col_name, col in model.columns.items() %}
                {{ log("    - " ~ col_name ~ ": " ~ (col.description | default('No description')), info=True) }}
            {% endfor %}
        {% endif %}
    {% endfor %}
    
    {{ log("", info=True) }}
    {{ log("=== End of Models List ===", info=True) }}
{% endmacro %}
