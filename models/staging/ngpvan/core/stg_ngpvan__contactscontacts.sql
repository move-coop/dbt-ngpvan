
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactscontacts') }}
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
            contactscontactid AS contacts_contact_id,
            vanid AS van_id,
            resultid AS result_id,
            COALESCE(resultshortname, results.resultshortname) AS result_type,
            COALESCE(committeeid, personcommitteeid) AS committee_id,
            COALESCE(committeename, committees.committeename) AS committee_name,
            {{ normalize_timestamp_to_utc('datecreated') }} AS utc_created_at,
            {{ normalize_timestamp_to_utc('datecanvassed') }} AS utc_canvassed_at,
            inputtypeid AS input_type_id,
            COALESCE(inputtypename, inputtypes.inputtypename) AS input_type,
            contacttypeid AS contact_type_id,
            COALESCE(contacttypename, contacttypes.contacttypename) AS contact_type,
            username,
            canvassedby AS canvassed_by_user_id,
            campaignid AS campaign_id,
            contentid AS content_id,
            createdby AS created_by_user_id,
            contactsphoneid AS contacts_phone_id,
            teamid AS team_id,
            divisionid AS division_id,
            {{ normalize_timestamp_to_utc('datemodified') }} AS utc_modified_at,

            -- additional columns
            {{ metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(segment_by, '-', contactscontactid) AS segmented_contacts_contact_id,
            CONCAT(segment_by, '-', vanid) AS segmented_van_id

        FROM base
        LEFT JOIN results USING (resultid)
        LEFT JOIN committees USING (committeeid)
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)

    )

SELECT * FROM renamed
