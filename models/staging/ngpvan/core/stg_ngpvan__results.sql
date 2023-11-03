
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
            {{ ngpvan__metadata__select_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

