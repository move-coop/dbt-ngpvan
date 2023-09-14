
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='inputtypes',
            source_tables_variable='inputtypes'
        )
    }}

)

, segment_by AS (

    SELECT
        *,
        NULL::int as committeeid

    FROM base
)


SELECT 
    *,
    {{ 
    staging_metadata_fields(
        vendor='van',
        segment_by_column='committeeid',
        segment_primary_keys=['inputtypeid']
    ) 
    }}
FROM segment_by
