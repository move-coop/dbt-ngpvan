WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__surveyquestions') }}
    ), 

    renamed as (
        SELECT
            surveyquestionid AS survey_question_id,
            stateid AS van_state_id,
            cycle AS election_cycle,
            surveyquestiontype AS survey_question_type,
            surveyquestionname AS survey_question_name,
            surveyquestiontext AS survey_question_text,
            mastersurveyquestionid AS master_survey_question_id,
            createdcommitteeid AS committee_id,
            CASE WHEN active = 1
                    THEN TRUE
                    ELSE FALSE
                END AS is_active,
            CASE WHEN active = 5
                    THEN TRUE
                    ELSE FALSE
                END AS is_archived,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__surveyquestions") }}
            {{ ngpvan__metadata__select_fields(from_cte='base') }},
            CONCAT(segment_by, '-', surveyquestionid) AS segmented_survey_question_id
            {{ ngpvan__stg__additional_fields() }}
        FROM base
    )

SELECT * FROM renamed
-- We get some data from both Bonterra and AV, so this dedupes by partitioning on 
-- everything except variables defining the source (i.e. _dbt_source_relation, _avvan_source_relation,
-- source_schema, source_table)
QUALIFY ROW_NUMBER() OVER (PARTITION BY 
    survey_question_id, 
    van_state_id, 
    election_cycle, 
    survey_question_type, 
    urvey_question_name, 
    survey_question_text, 
    master_survey_question_id, 
    committee_id, 
    is_active, 
    is_archived,
    segment_by,
    segmented_survey_question_id,
    vendor,
    segment_by_key,
    vendor_unique_stg_ngpvan__survey_question_id) = 1
