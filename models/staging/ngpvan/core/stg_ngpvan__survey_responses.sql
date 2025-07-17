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
            CASE WHEN base.mastersurveyresponseid = 0 THEN NULL ELSE base.mastersurveyresponseid END AS master_survey_response_id,
            base.committeeid AS committee_id,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__surveyresponses") }}
            {{ ngpvan__metadata__select_fields(from_cte='base', segment_by='surveyquestions.segment_by') }},
            CONCAT(surveyquestions.segment_by, '-', base.surveyresponseid) AS segmented_survey_response_id,
            CONCAT(surveyquestions.segment_by, '-', base.surveyquestionid) AS segmented_survey_question_id
            {{ ngpvan__stg__additional_fields() }}
        FROM base
        LEFT JOIN surveyquestions USING (surveyquestionid)
    ),

    dedupe AS (
        SELECT 
            DISTINCT
            survey_question_id,
            survey_response_id,
            survey_response,
            democrat_points,
            republican_points,
            independent_points,
            master_survey_response_id,
            committee_id,
            STRING_AGG(_avvan_source_relation) AS _avvan_source_relation,
            STRING_AGG(_dbt_source_relation) AS _dbt_source_relation,
            STRING_AGG(source_schema) AS source_schema,
            STRING_AGG(source_table) AS source_table,
            segment_by,
            segmented_survey_response_id,
            segmented_survey_question_id,
            vendor,
            segment_by_key,
            vendor_unique_stg_ngpvan__survey_response_id
        FROM responses
        GROUP BY ALL
    )

SELECT DISTINCT * FROM dedupe
