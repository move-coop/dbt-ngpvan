
WITH
    base AS (
        SELECT * FROM {{ ref('base_van__surveyquestions') }}
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
    active AS is_active,
    _dbt_source_relation,
    source_schema,
    source_table,
    vendor,
    segment_by,
    CONCAT(segment_by, '-', surveyquestionid) AS segmented_survey_question_id

FROM base

