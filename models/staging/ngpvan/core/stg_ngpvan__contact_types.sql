
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contacttypes') }}
    ),

    renamed AS (
        SELECT
            contacttypeid AS contact_method_type_id,
            contacttypename AS contact_method_type,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__contacttypes") }}
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

