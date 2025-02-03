{% test test_source_row_counts(model, source_references=[]) %}
    {% set source_row_count = 0 %}
    {% for source_table in source_references %}
        {% set source_row_count = source_row_count + run_query("SELECT COUNT(*) FROM {{ source['source'] }}").columns[0][0] %}
    {% endfor %}
    
    WITH
        current_model_row_count AS (
            SELECT
                
                COUNT(*) AS n

            FROM {{ model }}
        )

    SELECT current_model_row_count = {{ source_row_count }}
{% endtest %}