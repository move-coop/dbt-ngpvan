
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='surveyquestions',
            source_tables_variable='surveyquestions'
        )
    }}

)

, segment_by AS (

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
        segment_by_column='committeeid',
        segment_primary_keys=['surveyquestionid']
    )
    }}
FROM segment_by
