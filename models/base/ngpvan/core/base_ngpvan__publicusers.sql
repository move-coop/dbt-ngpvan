
WITH
    base AS (

        {{
            union_source_tables(
                table_pattern='publicusers'
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
        segment_by_column='committeeid'
    )
    }}
FROM segment_by
