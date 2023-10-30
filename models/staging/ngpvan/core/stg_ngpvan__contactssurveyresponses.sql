
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactssurveyresponses') }}
    ),

    results AS (
        SELECT * FROM {{ ref('base_ngpvan__results') }}
    ),

    committees AS (
        SELECT * FROM {{ ref('base_ngpvan__committees') }}
    ),

    inputtypes AS (
        SELECT * FROM {{ ref('base_ngpvan__inputtypes') }}
    ),

    contacttypes AS (
        SELECT * FROM {{ ref('base_ngpvan__contacttypes') }}
    ),

    campaigns AS (
        SELECT * FROM {{ ref('base_ngpvan__campaigns') }}
    ),

    renamed AS (
        SELECT
            statecode AS van_state_code,
            contactssurveyresponseid AS contacts_survey_response_id,
            vanid AS van_id,
            contactscontactid AS contacts_contact_id,
            surveyquestionid AS survey_question_id,
            surveyresponseid AS survey_response_id,
            {{ normalize_timestamp_to_utc('datecreated') }} AS utc_created_at,
            {{ normalize_timestamp_to_utc('datecanvassed') }} AS utc_canvassed_at,
            inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            contacttypeid AS contact_type_id,
            contacttypes.contacttypename AS contact_type,
            committeeid AS committee_id,
            committees.committeename AS committee_name,
            username,
            canvassedby AS canvassed_by_user_id,
            campaignid AS campaign_id,
            campaigns.campaignname AS campaign_name,
            contentid AS content_id,
            {{ normalize_timestamp_to_utc('datemodified') }} AS utc_modified_at,
            teamid AS team_id,
            divisionid AS division_id,

            -- additional columns
            {{ metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(segment_by, '-', contactssurveyresponseid) AS segmented_contacts_survey_response_id,
            CONCAT(segment_by, '-', vanid) AS segmented_van_id

        FROM base
        LEFT JOIN results USING (resultid)
        LEFT JOIN committees USING (committeeid)
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)
    )

SELECT * FROM renamed

