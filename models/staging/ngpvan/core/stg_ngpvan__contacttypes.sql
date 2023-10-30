
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contacttypes') }}
    ),

    renamed AS (
        SELECT
            contacttypeid AS contact_type_id,
            contacttypename AS contact_type,
            _dbt_source_relation,
            source_schema,
            source_table,
            vendor

        FROM base
    )

SELECT
    *
FROM renamed

