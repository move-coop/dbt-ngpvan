
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contactssurveyresponses'
    )
}}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='contactssurveyresponses'
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
