{% macro metadata__generate_fields(vendor, segment_by_column=none, myvoters=false) -%}



    SPLIT(REPLACE(_dbt_source_relation, '"', ''), '.')[1] AS source_schema,
    SPLIT(REPLACE(_dbt_source_relation, '"', ''), '.')[2] AS source_table,

    {%- if myvoters == true %}
    CASE WHEN RIGHT(SPLIT(REPLACE(_dbt_source_relation, '"', ''), '.')[2], 3) IN ('_vf', 'myv')
            THEN 0
            ELSE 1
        END AS database_mode,
    CASE WHEN RIGHT(SPLIT(REPLACE(_dbt_source_relation, '"', ''), '.')[2], 3) IN ('_vf', 'myv')
            THEN TRUE
            ELSE FALSE
        END AS is_myvoters,
    {% endif -%}
    '{{ vendor }}' AS vendor
    {%- if segment_by_column -%}
        ,
        {{ segment_by_column }} AS segment_by
    {% endif -%}

{%- endmacro %}