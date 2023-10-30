
WITH
    base AS (
        SELECT * FROM {{ ref('base_van__codetypes') }}
    ),

    renamed AS (
        SELECT
            codetypeid AS code_type_id,
            codetypename AS code_type,
            _dbt_source_relation,
            source_schema,
            source_table,
            vendor

        FROM base
    )

SELECT
    *
FROM renamed

