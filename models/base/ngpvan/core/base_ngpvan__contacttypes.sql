
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contacttypes'
    )
}}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='contacttypes'
            )
        }}

    ),

    segment_by AS (

        SELECT
            *

        FROM base
    )


SELECT
    *,
    {{
    ngpvan__metadata__generate_fields(
        segment_by_column='NULL'
    )
    }}
FROM segment_by
