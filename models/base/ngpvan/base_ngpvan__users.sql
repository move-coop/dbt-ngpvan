
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__users'
    )
}}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='users'
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
