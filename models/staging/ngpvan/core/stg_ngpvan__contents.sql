WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contents') }}
    ),

    content_types AS (
        SELECT * FROM {{ ref('base_ngpvan__contenttypes') }}
    ),

    renamed AS (
        SELECT
            base.contentid AS content_id,
            base.contentname AS content_name,
            base.contenttypeid as content_type_id,
            content_types.committeeid AS committee_id,
            
            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__contents") }}
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
        LEFT JOIN content_types USING (contentypeid)
    )

SELECT
    *
FROM renamed

