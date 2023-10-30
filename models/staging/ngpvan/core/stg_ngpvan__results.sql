
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__results') }}
    ),

    renamed AS (
        SELECT
            resultid AS result_id,
            resultshortname AS result_name,
            resultdescription AS result_description,
            _dbt_source_relation,
            source_schema,
            source_table,
            vendor

        FROM base
    )

SELECT
    *
FROM renamed

