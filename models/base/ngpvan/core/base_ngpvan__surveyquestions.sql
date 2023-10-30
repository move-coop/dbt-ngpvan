
WITH
    base AS (

        {{
            union_source_tables(
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
    generate_metadata_fields(
        vendor='van',
        segment_by_column='committeeid'
    )
    }}
FROM segment_by
