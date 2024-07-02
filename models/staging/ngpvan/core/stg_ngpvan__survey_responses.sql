WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__surveyresponses') }}
    ),

    surveyquestions AS (
        SELECT
            surveyquestionid,
            createdcommitteeid AS committeeid,
            createdcommitteeid AS segment_by
        FROM {{ ref('base_ngpvan__surveyquestions') }}
    ),

    responses AS (
        SELECT
            surveyquestionid AS survey_question_id,
            base.surveyresponseid AS survey_response_id,
            base.surveyresponsename AS survey_response,
            base.dempoints AS democrat_points,
            base.reppoints AS republican_points,
            base.indpoints AS independent_points,
            base.mastersurveyresponseid AS master_survey_response_id,
            surveyquestions.committeeid AS committee_id,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__surveyresponses") }}
            {{ ngpvan__metadata__select_fields(from_cte='base', segment_by='surveyquestions.segment_by') }},
            CONCAT(surveyquestions.segment_by, '-', base.surveyresponseid) AS segmented_survey_response_id,
            CONCAT(surveyquestions.segment_by, '-', base.surveyquestionid) AS segmented_survey_question_id
            {{ ngpvan__stg__additional_fields() }}
        FROM base
        LEFT JOIN surveyquestions USING (surveyquestionid)
    )

SELECT * FROM responses