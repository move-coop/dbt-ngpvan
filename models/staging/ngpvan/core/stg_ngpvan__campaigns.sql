
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__campaigns') }}
    ),

    renamed AS (
        SELECT
            campaignid AS campaign_id,
            campaignname AS campaign_name,
            campaigndescription AS campaign_description,
            committeeid AS committee_id,
            campaigntypeid AS campaign_type_id,
            campaigntypename AS campaign_type,
            {{ normalize_timestamp_to_utc('datecreated')}} AS created_at,
            createdby AS created_by_user_id,
            CASE WHEN active = 1
                    THEN TRUE
                    ELSE FALSE
                END AS is_active,
            CASE WHEN active = 5
                    THEN TRUE
                    ELSE FALSE
                END AS is_archived,

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base') }},
            CONCAT(segment_by, '-', campaignid) AS segmented_campaign_id
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    *
FROM renamed

