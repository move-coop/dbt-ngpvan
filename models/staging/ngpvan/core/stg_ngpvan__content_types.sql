WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contenttypes') }}
    ),

    renamed AS (
        SELECT
            contenttypeid AS content_type_id,
            contenttypename AS content_type_name,
            committeeid AS committee_id,
            suppressedby AS suppressed_by,
            {{ normalize_timestamp_to_utc('datesuppressed') }} AS utc_date_suppressed,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__contenttypes") }}
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

