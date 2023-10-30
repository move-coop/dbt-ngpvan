
WITH
    base AS (
        SELECT * FROM {{ ref('base_van__surveyresponses') }}
    ),

    surveyquestions AS (
        SELECT
            surveyquestionid,
            createdcommitteeid,
            createdcommitteeid AS segment_by
        FROM {{ ref('base_van__surveyquestions') }}
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
            base._dbt_source_relation,
            base.source_schema,
            base.source_table,
            base.vendor,
            surveyquestions.segment_by,
            CONCAT(surveyquestions.segment_by, '-', base.surveyresponseid) AS segmented_survey_response_id
        FROM base
        LEFT JOIN surveyquestions USING (surveyquestionid)
    )

SELECT * FROM responses