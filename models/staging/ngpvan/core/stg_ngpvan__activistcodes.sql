
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__activistcodes'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__activistcodes') }}
    ),

    renamed AS (
        SELECT
            activistcodeid AS activist_code_id,
            stateid AS van_state_id,
            activistcodetype AS activist_code_type,
            activistcodename AS activist_code_name,
            activistcodedescription AS activist_code_description,
            reportquestion AS report_question,
            dempoints AS democrat_points,
            reppoints AS republican_points,
            indpoints AS independent_points,
            committeeid AS committee_id,
            actiontypeid AS action_type_id,
            campaignid AS campaign_id,
            active AS active_status_id,

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base') }},
            CONCAT(segment_by, '-', activistcodeid) AS segmented_activist_code_id

        FROM base
    )

SELECT
    *
FROM renamed

