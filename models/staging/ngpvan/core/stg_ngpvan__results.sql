
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__results') }}
    ),

    renamed AS (
        SELECT
            resultid AS result_id,
            resultshortname AS result_name,
            resultdescription AS result_description,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__results") }}
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

