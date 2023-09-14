
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='contactsnotes',
            source_tables_variable='contactsnotes'
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
        segment_primary_keys=['contactsnoteid']
    ) 
    }}
FROM segment_by
