
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='codes',
            source_tables_variable='codes'
        )
    }}

)

, segment_by AS (

    SELECT
        *

    FROM base
)


SELECT
    *,
    {{
    generate_metadata_fields(
        vendor='van',
        segment_by_column='committeeid',
        segment_primary_keys=['codeid']
    )
    }}
FROM segment_by
