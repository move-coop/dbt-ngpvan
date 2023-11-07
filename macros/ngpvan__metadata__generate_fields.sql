{% macro ngpvan__metadata__generate_fields(segment_by_column=none, myvoters=false) -%}
    {{ return(adapter.dispatch('ngpvan__metadata__generate_fields', 'dbt_ngpvan')(segment_by_column, myvoters)) }}
{%- endmacro %}


{% macro default__ngpvan__metadata__generate_fields(segment_by_column, myvoters) -%}
    SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[1] AS source_schema,
    SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[2] AS source_table

    {%- if myvoters == true -%}
    ,
    CASE WHEN RIGHT(SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[2], 3) IN ('_vf', 'myv')
            THEN 0
            ELSE 1
        END AS database_mode,
    CASE WHEN RIGHT(SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[2], 3) IN ('_vf', 'myv')
            THEN TRUE
            ELSE FALSE
        END AS is_myvoters
    {%- endif -%}
    {%- if segment_by_column -%}
    ,
    {{ segment_by_column }} AS segment_by
    {%- endif -%}

{%- endmacro %}

{% macro bigquery__ngpvan__metadata__generate_fields(segment_by_column, myvoters) -%}
    SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[1] AS source_schema,
    SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[2] AS source_table

    {%- if myvoters == true -%}
    ,
    CASE WHEN RIGHT(SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[2], 3) IN ('_vf', 'myv')
            THEN 0
            ELSE 1
        END AS database_mode,
    CASE WHEN RIGHT(SPLIT(REPLACE(_dbt_source_relation, '`', ''), '.')[2], 3) IN ('_vf', 'myv')
            THEN TRUE
            ELSE FALSE
        END AS is_myvoters
    {%- endif -%}
    {%- if segment_by_column -%}
    ,
    {{ segment_by_column }} AS segment_by
    {%- endif -%}

{%- endmacro %}

{% macro redshift__ngpvan__metadata__generate_fields(segment_by_column, myvoters) -%}
    SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 1) AS source_schema,
    SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 2) AS source_table

    {%- if myvoters == true -%}
    ,
    CASE WHEN RIGHT(SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 2), 3) IN ('_vf', 'myv')
            THEN 0
            ELSE 1
        END AS database_mode,
    CASE WHEN RIGHT(SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 2), 3) IN ('_vf', 'myv')
            THEN TRUE
            ELSE FALSE
        END AS is_myvoters
    {%- endif -%}
    {%- if segment_by_column -%}
    ,
    {{ segment_by_column }} AS segment_by
    {%- endif -%}

{%- endmacro %}