
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__committees'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__committees') }}
    ),

    renamed AS (
        SELECT
            committeeid AS committee_id,
            stateid AS van_state_id,
            committeename AS committee_name,
            committeeshortname AS committee_short_name,
            committeetypename AS committee_type,
            active AS active_status_id,
            parentcommitteeid AS parent_committee_id,
            mastercommitteeid AS master_committee_id,

            -- additional columns
            {{ ngpvan__metadata__select_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

