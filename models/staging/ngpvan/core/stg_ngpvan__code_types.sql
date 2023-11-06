
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__codetypes') }}
    ),

    renamed AS (
        SELECT
            codetypeid AS code_type_id,
            codetypename AS code_type,

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base') }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

