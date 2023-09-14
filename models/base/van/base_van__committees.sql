
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='committees',
            source_tables_variable='committees'
        )
    }}

)

, segment_by AS (

    SELECT
        *,
        committeeid

    FROM base
)


SELECT 
    *,
    {{ 
    staging_metadata_fields(
        vendor='van',
        segment_by_column='committeeid',
        segment_primary_keys=['committeeid']
    ) 
    }}
FROM segment_by
