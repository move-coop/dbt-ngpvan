
WITH
    base AS (

        {{
            union_source_tables(
                table_pattern='contactsnotes'
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
    metadata__generate_fields(
        vendor='van',
        segment_by_column='committeeid',
        myvoters=var('dbt_ngpvan_config')['packages']['myvoters']['enabled']
    )
    }}
FROM segment_by
