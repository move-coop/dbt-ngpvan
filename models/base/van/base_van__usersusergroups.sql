
WITH base AS (

    {{
        union_all_by_var(
            source_variable='van',
            default_source_table='usersusergroups',
            source_tables_variable='usersusergroups'
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
    generate_metadata_fields(
        vendor='van',
        segment_by_column='committeeid',
        segment_primary_keys=['userid', 'usergroupid']
    )
    }}
FROM segment_by
