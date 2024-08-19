
WITH
    contacts AS (
        SELECT * FROM {{ ref("stg_ngpvan__contacts_activist_codes") }}
    ),

    codes AS (
        SELECT
            segmented_activist_code_id,
            activist_code_id,
            van_state_id AS activist_code_van_state_id,
            activist_code_type,
            activist_code_name,
            activist_code_description,
            report_question,
            democrat_points,
            republican_points,
            independent_points,
            committee_id AS activist_code_committee_id,
            action_type_id,
            --campaign_id,
            is_active,
            is_archived,
            _dbt_source_relation,
            source_schema,
            source_table,
            segment_by
        FROM {{ ref("stg_ngpvan__activist_codes") }}
    ),

    committees AS (
        SELECT DISTINCT
            committee_id,
            committee_name,
            committee_short_name,
            committee_type
        FROM {{ ref("stg_ngpvan__committees") }}
    ),

    campaigns AS (
        SELECT
            campaign_id,
            campaign_name
        FROM {{ ref("stg_ngpvan__campaigns") }}
    ),

    activist_codes AS (
        SELECT
            contacts.van_state_code,
            contacts.segmented_contacts_activist_code_id,
            contacts.contacts_activist_code_id,
            contacts.utc_created_at,
            contacts.utc_modified_at,
            contacts.segmented_van_id,
            contacts.van_id,
            contacts.segmented_activist_code_id,
            contacts.activist_code_id,
            codes.activist_code_type,
            codes.activist_code_name,
            codes.activist_code_description,
            codes.activist_code_committee_id,
            codes.is_active AS is_active_activist_code,
            codes.is_archived AS is_archived_activist_code,
            contacts.committee_id,
            committees.committee_name,
            committees.committee_short_name,
            committees.committee_type,
            contacts.input_type_id,
            contacts.input_type,
            contacts.contact_method_type_id,
            contacts.contact_method_type,
            contacts.utc_canvassed_at,
            contacts.canvassed_by_username,
            contacts.canvassed_by_user_id,
            contacts.campaign_id,
            campaigns.campaign_name,
            contacts.content_id,
            contacts.contacts_contact_id,

            -- additional columns
            contacts.database_mode,
            contacts.is_myvoters,
            contacts._dbt_source_relation,
            contacts.source_schema,
            contacts.source_table,
            contacts.segment_by
            {{ ngpvan__int__additional_fields() }}

        FROM contacts
        LEFT JOIN codes USING (activist_code_id)
        LEFT JOIN committees USING (committee_id)
        LEFT JOIN campaigns USING (campaign_id)
    )

SELECT * FROM activist_codes