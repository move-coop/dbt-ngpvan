
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactsactivistcodes') }}
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
            base.statecode AS van_state_code,
            base.contactsactivistcodeid AS contacts_activist_code_id,
            base.vanid AS van_id,
            base.activistcodeid AS activist_code_id,
            base.committeeid AS committee_id,
            committees.committeename AS committee_name,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            contacttypeid AS contact_type_id,
            contacttypes.contacttypename AS contact_type,
            base.username,
            base.canvassedby AS canvassed_by_user_id,
            campaignid AS campaign_id,
            campaigns.campaignname AS campaign_name,
            base.contentid AS content_id,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,
            base.contactscontactid AS contacts_contact_id,
            {{ normalize_timestamp_to_utc('base.datecanvassed') }} AS utc_canvassed_at,

            {{ metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(base.segment_by, '-', base.contactsactivistcodeid) AS segmented_contacts_activist_code_id,
            CONCAT(base.segment_by, '-', base.activistcodeid) AS segmented_activist_code_id,
            CONCAT(base.segment_by, '-', base.vanid) AS segmented_van_id

        FROM base
        LEFT JOIN results USING (resultid)
        LEFT JOIN committees USING (committeeid)
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)
    )

SELECT * FROM renamed

