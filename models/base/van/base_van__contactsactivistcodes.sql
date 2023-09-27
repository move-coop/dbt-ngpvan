
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='contactsactivistcodes',
            source_tables_variable='contactsactivistcodes'
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
    staging_metadata_fields(
        vendor='van',
        segment_by_column='committeeid',
        segment_primary_keys=['contactsactivistcodeid']
    ) 
    }}
FROM segment_by
