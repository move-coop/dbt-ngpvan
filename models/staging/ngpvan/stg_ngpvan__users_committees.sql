
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__userscommittees') }}
    ),

    renamed AS (
        SELECT

            UserID AS user_id,
            CommitteeID AS committee_id,
            StateID AS state_id,
            CreatedBy AS created_by_user_id,
            {{ normalize_timestamp_to_utc('DateCreated') }} AS utc_created_at,
            {{ normalize_timestamp_to_utc('DateModified') }} AS utc_modified_at,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__userscommittees") }}
            {{ ngpvan__metadata__select_fields(from_cte='base') }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

