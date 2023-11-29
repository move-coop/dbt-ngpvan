{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__activistcodes'
    )
}}


WITH
    base AS (

    {{
        ngpvan__union_source_tables(
            table_pattern='activistcodes'
        )
    }}

    ),

    segment_by AS (

        SELECT
            *,
            committeecreatedby as committeeid

        FROM base
    )


SELECT
    *,
    {{
    ngpvan__metadata__generate_fields(
        segment_by_column='committeeid'
    )
    }}
FROM segment_by
