
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
            CASE WHEN actiontypeid = 0 THEN NULL ELSE actiontypeid END AS action_type_id,
            CASE WHEN campaignid = 0 THEN NULL ELSE campaignid END AS campaign_id,
            CASE WHEN active = 1
                    THEN TRUE
                    ELSE FALSE
                END AS is_active,
            CASE WHEN active = 5
                    THEN TRUE
                    ELSE FALSE
                END AS is_archived,
            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__activistcodes") }}
            {{ ngpvan__metadata__select_fields(from_cte='base') }},
            CONCAT(segment_by, '-', activistcodeid) AS segmented_activist_code_id
            {{ ngpvan__stg__additional_fields() }}

        FROM base
        GROUP BY ALL
    ),

    dedupe AS (
        SELECT
            DISTINCT 
            vendor_unique_stg_ngpvan__activist_code_id,
            activist_code_id,
            van_state_id,
            activist_code_type,
            activist_code_name,
            activist_code_description,
            report_question,
            democrat_points,
            republican_points,
            independent_points,
            committee_id,
            MAX(action_type_id) AS action_type_id,
            campaign_id,
            LOGICAL_AND(is_active) AS is_active,
            LOGICAL_AND(is_archived) AS is_archived,
            segment_by,
            segmented_activist_code_id,
            vendor,
            segment_by_key,
            STRING_AGG(_avvan_source_relation) AS _avvan_source_relation,
            STRING_AGG(_dbt_source_relation) AS _dbt_source_relation,
            STRING_AGG(source_schema) AS source_schema,
            STRING_AGG(source_table) AS source_table
        FROM renamed
        GROUP BY ALL
    )

SELECT * FROM dedupe
