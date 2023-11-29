
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__surveyquestions'
    )
}}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='surveyquestions'
            )
        }}

    ),

    segment_by AS (

        SELECT
            *,
            createdcommitteeid as committeeid

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
