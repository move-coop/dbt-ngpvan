{% test table_fully_documented(model) %}
    {% set table_name = model.identifier %}
    SELECT
        column_name
    FROM 
        {{ model.database }}.{{ model.schema }}.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS
    WHERE 
        (description IS NULL OR description = '')
        AND table_name = '{{ table_name }}'
    UNION ALL
    SELECT '{{ table_name }}'
    FROM UNNEST([1]) AS dummy
    WHERE NOT EXISTS (
        SELECT 1
        FROM {{ model.database }}.{{ model.schema }}.INFORMATION_SCHEMA.TABLE_OPTIONS
        WHERE option_name = 'description'
        AND table_name = '{{ table_name }}'
    )
{% endtest %}