
WITH
    base AS (

    {{
            union_source_tables(
                table_pattern='contactscodes'
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
    generate_metadata_fields(
        vendor='van',
        segment_by_column='committeeid'
    )
    }}
FROM segment_by
