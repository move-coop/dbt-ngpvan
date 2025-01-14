
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contactscontacts',
        materialized="table",
        partition_by={
            "field": "datecanvassed",
            "data_type": "timestamp",
            "granularity": "day"
        }
    )
}}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='contactscontacts'
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
        segment_by_column='committeeid',
        myvoters=var('dbt_ngpvan_config')['packages']['myvoters']['enabled']
    )
    }}
FROM segment_by
