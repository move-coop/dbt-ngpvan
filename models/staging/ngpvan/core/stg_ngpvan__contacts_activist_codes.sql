
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactsactivistcodes') }}
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
            base.contactsactivistcodeid AS contacts_activist_code_id,
            base.vanid AS van_id,
            base.activistcodeid AS activist_code_id,
            base.committeeid AS committee_id,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            contacttypeid AS contact_method_type_id,
            contacttypes.contacttypename AS contact_method_type,
            base.username AS canvassed_by_username,
            base.canvassedby AS canvassed_by_user_id,
            base.campaignid AS campaign_id,
            base.contentid AS content_id,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,
            base.contactscontactid AS contacts_contact_id,
            {{ normalize_timestamp_to_utc('base.datecanvassed') }} AS utc_canvassed_at,

            -- additional fields
            {{ ngpvan__user__additional_fields("base_ngpvan__contactsactivistcodes") }}
            {{ ngpvan__metadata__select_fields(from_cte='base', myvoters=true) }},

            {{ ngpvan__stg__unique_id(columns=['base.segment_by', 'base.statecode', 'base.contactsactivistcodeid'], grain='contacts_activist_code') }},

            CONCAT(base.segment_by, '-', base.contactsactivistcodeid) AS segmented_contacts_activist_code_id,
            CONCAT(base.segment_by, '-', base.activistcodeid) AS segmented_activist_code_id,
            CONCAT(base.segment_by, '-', base.vanid) AS segmented_van_id

            {{ ngpvan__stg__additional_fields() }}

        FROM base
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)
    )

SELECT * FROM renamed

