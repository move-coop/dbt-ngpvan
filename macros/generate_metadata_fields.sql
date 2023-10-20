{% macro generate_metadata_fields(vendor, segment_by_column=none) -%}

    SPLIT(REPLACE(_dbt_source_relation, '"', ''), '.')[1] AS source_schema,
    SPLIT(REPLACE(_dbt_source_relation, '"', ''), '.')[2] AS source_table,
    '{{ vendor }}' AS vendor
    {%- if segment_by_column -%}
        ,
        {{ segment_by_column }} AS segment_by
    {% endif -%}

{%- endmacro %}