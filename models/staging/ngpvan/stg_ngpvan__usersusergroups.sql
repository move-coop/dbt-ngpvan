
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__usersusergroups'
    )
}}

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

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base') }}

        FROM base
    )

SELECT
    *
FROM renamed

