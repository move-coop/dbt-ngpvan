
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__publicusers') }}
    ),

    renamed AS (
        SELECT

            publicuserid AS public_user_id,
            publicusername AS public_username,
            vanid AS van_id,
            committeeid AS committee_id,
            {{ normalize_timestamp_to_utc('datecreated') }} AS created_at,

            -- additional columns
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

