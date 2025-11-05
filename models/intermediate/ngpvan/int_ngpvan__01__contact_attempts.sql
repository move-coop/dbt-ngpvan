
WITH
    contacts AS (
        SELECT * FROM {{ ref('stg_ngpvan__contacts_contacts') }}
    ),

    committees AS (
        SELECT DISTINCT
            committee_id,
            committee_name,
            committee_short_name,
            committee_type,
            segment_by
        FROM {{ ref("stg_ngpvan__committees") }}
    ),

    campaigns AS (
        SELECT
            campaign_id,
            campaign_name,
            committee_id,
            segment_by
        FROM {{ ref("stg_ngpvan__campaigns") }}
    ),

    contact_attempts AS (
        SELECT
            contacts.van_state_code,
            contacts.segmented_contacts_contact_id,
            contacts.contacts_contact_id,
            contacts.segmented_van_id,
            contacts.van_id,
            contacts.result_id,
            contacts.result_name,
            contacts.contact_method_type_id,
            contacts.contact_method_type,
            contacts.input_type_id,
            contacts.input_type,
            contacts.contacts_phone_id,
            contacts.committee_id,
            committees.committee_name,
            committees.committee_short_name,
            committees.committee_type,
            contacts.utc_created_at,
            contacts.utc_canvassed_at,
            contacts.utc_modified_at,
            contacts.canvassed_by_username,
            contacts.canvassed_by_user_id,
            contacts.content_id,
            contacts.created_by_user_id,
            contacts.campaign_id,
            campaigns.campaign_name,
            contacts.team_id,
            contacts.division_id,

            -- additional columns
            contacts.database_mode,
            contacts.is_myvoters,
            contacts._dbt_source_relation,
            contacts._avvan_source_relation,
            contacts.source_schema,
            contacts.source_table,
            contacts.segment_by
            {{ ngpvan__int__additional_fields() }}

        FROM contacts
        LEFT JOIN committees 
            ON contacts.committee_id = committees.committee_id 
                AND contacts.segment_by = committees.segment_by
        LEFT JOIN campaigns 
            ON contacts.campaign_id = campaigns.campaign_id 
                AND contacts.committee_id = campaigns.committee_id
                AND contacts.segment_by = campaigns.segment_by
    )

SELECT * FROM contact_attempts