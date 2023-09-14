
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='contactscontacts',
            source_tables_variable='contactscontacts'
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
        segment_primary_keys=['contactscontactid']
    ) 
    }}
FROM segment_by
