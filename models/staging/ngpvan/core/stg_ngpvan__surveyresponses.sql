
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__surveyresponses'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__surveyresponses') }}
    ),

    surveyquestions AS (
        SELECT
            surveyquestionid,
            createdcommitteeid,
            createdcommitteeid AS segment_by
        FROM {{ ref('base_ngpvan__surveyquestions') }}
    ),

    responses AS (
        SELECT
            surveyquestionid AS survey_question_id,
            base.surveyresponseid AS survey_response_id,
            base.surveyresponsename AS survey_response_name,
            base.dempoints AS democrat_points,
            base.reppoints AS republican_points,
            base.indpoints AS independent_points,
            base.mastersurveyresponseid AS master_survey_response_id,
            surveyquestions.createdcommitteeid AS committee_id,

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base', segment_by='surveyquestions.segment_by') }},
            CONCAT(surveyquestions.segment_by, '-', base.surveyresponseid) AS segmented_survey_response_id
        FROM base
        LEFT JOIN surveyquestions USING (surveyquestionid)
    )

SELECT * FROM responses