
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
            CASE WHEN active = 1
                    THEN TRUE
                    ELSE FALSE
                END AS is_active,
            CASE WHEN active = 5
                    THEN TRUE
                    ELSE FALSE
                END AS is_archived,
            parentcommitteeid AS parent_committee_id,
            mastercommitteeid AS master_committee_id,

            -- additional columns
            {{ ngpvan__metadata__select_fields() }}
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

