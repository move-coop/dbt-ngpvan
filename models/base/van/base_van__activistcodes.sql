
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='activistcodes',
            source_tables_variable='activistcodes'
        )
    }}

)

, segment_by AS (

    SELECT
        *,
        committeecreatedby as committeeid

    FROM base
)


SELECT
    *,
    {{
    generate_metadata_fields(
        vendor='van',
        segment_by_column='committeeid',
        segment_primary_keys=['activistcodeid']
    )
    }}
FROM segment_by
