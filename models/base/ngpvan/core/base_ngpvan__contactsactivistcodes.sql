
WITH
    base AS (

        {{
            union_source_tables(
                table_pattern='contactsactivistcodes'
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
        vendor='ngpvan',
        segment_by_column='committeeid',
        myvoters=var('dbt_ngpvan_config')['packages']['myvoters']['enabled']
    )
    }}
FROM segment_by
