
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
            CASE WHEN active = 1
                    THEN TRUE
                    ELSE FALSE
                END AS is_active,
            CASE WHEN active = 5
                    THEN TRUE
                    ELSE FALSE
                END AS is_archived,
            _avvan_source_relation,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__activistcodes") }}
            {{ ngpvan__metadata__select_fields(from_cte='base') }},
            CONCAT(segment_by, '-', activistcodeid) AS segmented_activist_code_id
            {{ ngpvan__stg__additional_fields() }}

        FROM base
    )

SELECT
    DISTINCT *
FROM renamed

