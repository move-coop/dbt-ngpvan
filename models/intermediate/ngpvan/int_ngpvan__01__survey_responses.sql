
WITH
    contacts AS (
        SELECT * FROM {{ ref("stg_ngpvan__contacts_survey_responses") }}
    ),

    responses AS (
        SELECT
            segmented_survey_question_id,
            survey_question_id,
            segmented_survey_response_id,
            survey_response_id,
            survey_response,
            democrat_points,
            republican_points,
            independent_points,
            master_survey_response_id,
            -- committee_id,
            segment_by
        FROM {{ ref("stg_ngpvan__survey_responses") }}
    ),

    questions AS (
        SELECT
            segmented_survey_question_id,
            survey_question_id,
            van_state_id AS survey_question_van_state_id,
            election_cycle AS survey_question_election_cycle,
            survey_question_type,
            survey_question_name,
            survey_question_text,
            master_survey_question_id,
            committee_id AS survey_question_committee_id,
            active_status_id
        FROM {{ ref("stg_ngpvan__survey_questions") }}
    ),

    committees AS (
        SELECT * FROM {{ ref("stg_ngpvan__committees") }}
    ),

    campaigns AS (
        SELECT * FROM {{ ref("stg_ngpvan__campaigns") }}
    ),

    survey_responses AS (
        SELECT
            contacts.segmented_contacts_survey_response_id,
            contacts.contacts_survey_response_id,
            contacts.segmented_van_id,
            contacts.van_id,
            contacts.van_state_code,
            contacts.contacts_contact_id,
            contacts.survey_question_id,
            questions.survey_question_type,
            questions.survey_question_name,
            questions.survey_question_text,
            contacts.survey_response_id,
            responses.survey_response,
            contacts.utc_created_at,
            contacts.utc_canvassed_at,
            contacts.utc_modified_at,
            questions.survey_question_election_cycle,
            questions.survey_question_van_state_id,
            questions.survey_question_committee_id,
            contacts.input_type_id,
            contacts.input_type,
            contacts.contact_method_type_id,
            contacts.contact_method_type,
            contacts.committee_id,
            committees.committee_name,
            contacts.canvassed_by_user_id,
            contacts.canvassed_by_username,
            contacts.campaign_id,
            campaigns.campaign_name,
            contacts.content_id,
            contacts.team_id,
            contacts.division_id,

            -- additional columns
            contacts.database_mode,
            contacts.is_myvoters,
            contacts._dbt_source_relation,
            contacts.source_schema,
            contacts.source_table,
            contacts.segment_by
            {{ ngpvan__int__additional_fields() }}


        FROM contacts
        LEFT JOIN responses USING (survey_question_id, survey_response_id)
        LEFT JOIN questions USING (survey_question_id)
        LEFT JOIN committees USING (committee_id)
        LEFT JOIN campaigns USING (campaign_id)
    )

SELECT * FROM survey_responses