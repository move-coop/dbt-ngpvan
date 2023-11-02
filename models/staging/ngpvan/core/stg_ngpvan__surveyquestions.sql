
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__surveyquestions'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__surveyquestions') }}
    )

SELECT
    surveyquestionid AS survey_question_id,
    stateid AS van_state_id,
    cycle AS election_cycle,
    surveyquestiontype AS survey_question_type,
    surveyquestionname AS survey_question_name,
    surveyquestiontext AS survey_question_text,
    mastersurveyquestionid AS master_survey_question_id,
    createdcommitteeid AS committee_id,
    active AS active_status_id,

    -- additional columns
    {{ ngpvan__metadata__select_fields(from_cte='base') }},
    CONCAT(segment_by, '-', surveyquestionid) AS segmented_survey_question_id

FROM base

