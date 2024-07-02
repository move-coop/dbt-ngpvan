
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__inputtypes') }}
    ),

    renamed AS (
        SELECT
            inputtypeid AS input_type_id,
            inputtypename AS input_type,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__inputtypes") }}
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

