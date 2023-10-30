
WITH
    base AS (
        SELECT * FROM {{ ref('base_van__contactsactivistcodes') }}
    ),

    results AS (
        SELECT * FROM {{ ref('base_van__results') }}
    ),

    committees AS (
        SELECT * FROM {{ ref('base_van__committees') }}
    ),

    inputtypes AS (
        SELECT * FROM {{ ref('base_van__inputtypes') }}
    ),

    contacttypes AS (
        SELECT * FROM {{ ref('base_van__contacttypes') }}
    ),

    campaigns AS (
        SELECT * FROM {{ ref('base_van__campaigns') }}
    ),

    renamed AS (
        SELECT
            statecode AS van_state_code,
            contactsactivistcodeid AS contacts_activist_code_id,
            vanid AS van_id,
            activistcodeid AS activist_code_id,
            committeeid AS committee_id,
            committees.committeename AS committee_name,
            {{ normalize_timestamp_to_utc('datecreated') }} AS utc_created_at,
            inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            contacttypeid AS contact_type_id,
            contacttypes.contacttypename AS contact_type,
            username,
            canvassedby AS canvassed_by_user_id,
            campaignid AS campaign_id,
            campaigns.campaignname AS campaign_name,
            contentid AS content_id,
            {{ normalize_timestamp_to_utc('datemodified') }} AS utc_modified_at,
            contactscontactid AS contacts_contact_id,
            {{ normalize_timestamp_to_utc('datecanvassed') }} AS utc_canvassed_at,
            _dbt_source_relation,
            source_schema,
            source_table,
            vendor,
            segment_by,
            CONCAT(segment_by, '-', contactsactivistcodeid) AS segmented_contacts_activist_code_id,
            CONCAT(segment_by, '-', activistcodeid) AS segmented_activist_code_id,
            CONCAT(segment_by, '-', vanid) AS segmented_van_id
        FROM base
        LEFT JOIN results USING (resultid)
        LEFT JOIN committees USING (committeeid)
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)
    )

SELECT * FROM renamed

