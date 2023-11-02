
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__campaigns'
    )
}}

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
            isactive AS active_status_id, --[0, 1, 5] unclear what these status ids translate to

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base') }},
            CONCAT(segment_by, '-', campaignid) AS segmented_campaign_id

        FROM base
    )

SELECT
    *
FROM renamed

