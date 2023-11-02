{{
    config(
        enabled=var('dbt_ngpvan_config')['lookup_tables'],
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contacttypes'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contacttypes') }}
    ),

    renamed AS (
        SELECT
            contacttypeid AS contact_type_id,
            contacttypename AS contact_type,

            -- additional columns
            {{ ngpvan__metadata__select_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

