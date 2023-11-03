
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactssurveyresponses') }}
    ),

    inputtypes AS (
        SELECT * FROM {{ ref('base_ngpvan__inputtypes') }}
    ),

    contacttypes AS (
        SELECT * FROM {{ ref('base_ngpvan__contacttypes') }}
    ),

    renamed AS (
        SELECT
            base.statecode AS van_state_code,
            base.contactssurveyresponseid AS contacts_survey_response_id,
            base.vanid AS van_id,
            base.contactscontactid AS contacts_contact_id,
            base.surveyquestionid AS survey_question_id,
            base.surveyresponseid AS survey_response_id,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            {{ normalize_timestamp_to_utc('base.datecanvassed') }} AS utc_canvassed_at,
            inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            contacttypeid AS contact_method_type_id,
            contacttypes.contacttypename AS contact_method_type,
            base.committeeid AS committee_id,
            base.username AS canvassed_by_username,
            base.canvassedby AS canvassed_by_user_id,
            base.campaignid AS campaign_id,
            base.contentid AS content_id,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,
            base.teamid AS team_id,
            base.divisionid AS division_id,

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(base.segment_by, '-', base.contactssurveyresponseid) AS segmented_contacts_survey_response_id,
            CONCAT(base.segment_by, '-', base.vanid) AS segmented_van_id

        FROM base
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)
    )

SELECT * FROM renamed

