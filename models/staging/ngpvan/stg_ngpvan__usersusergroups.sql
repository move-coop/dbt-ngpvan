
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__usersusergroups') }}
    ),

    renamed AS (
        SELECT

            userid AS user_id,
            usergroupid AS user_group_id,
            usergroupname AS user_group_name,
            {{ normalize_timestamp_to_utc('datecreated') }} AS created_at,
            createdby AS created_by_user_id,
            _dbt_source_relation,
            source_schema,
            source_table,
            vendor,
            NULL AS segment_by

        FROM base
    )

SELECT
    *
FROM renamed

