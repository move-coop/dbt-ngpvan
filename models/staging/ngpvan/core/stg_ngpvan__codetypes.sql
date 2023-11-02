{{
    config(
        enabled=var('dbt_ngpvan_config')['lookup_tables'],
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__codetypes'
    )
}}

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

        FROM base
    )

SELECT
    *
FROM renamed

