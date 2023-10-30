
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__inputtypes') }}
    ),

    renamed AS (
        SELECT
            inputtypeid AS input_type_id,
            inputtypename AS input_type,
            _dbt_source_relation,
            source_schema,
            source_table,
            vendor

        FROM base
    )

SELECT
    *
FROM renamed

