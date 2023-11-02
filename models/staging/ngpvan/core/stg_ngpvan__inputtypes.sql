{{
    config(
        enabled=var('dbt_ngpvan_config')['lookup_tables'],
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__inputtypes'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__inputtypes') }}
    ),

    renamed AS (
        SELECT
            inputtypeid AS input_type_id,
            inputtypename AS input_type,

            -- additional columns
            {{ ngpvan__metadata__select_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

