-- NOTE - This is a TMC macro, see `dbt-tmc`
{%- set partitions_to_replace = generate_partitions_to_replace(
            incremental_window=var('dbt_ngpvan_config')["ngpvan_default_incremental_window_days"],
            date_part="day"
        ) 
-%}

{{
    config(
        materialized="incremental",
        partition_by={
            "field": "utc_canvassed_at",
            "data_type": "timestamp",
            "granularity": "month"
        },
        incremental_strategy="insert_overwrite",
        require_partition_filter=false,
        partitions=partitions_to_replace
    )
}}


WITH
    base AS (
        SELECT 
        
            * 
        
        FROM {{ ref('base_ngpvan__contactscontacts') }}
        {% if is_incremental() %}
        WHERE TIMESTAMP_TRUNC(CAST(datecanvassed AS TIMESTAMP), DAY) IN ({{ partitions_to_replace | join(",") }})
        {% endif %}
    ),

    results AS (
        SELECT * FROM {{ ref('base_ngpvan__results') }}
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
            base.contactscontactid AS contacts_contact_id,
            base.vanid AS van_id,
            resultid AS result_id,
            results.resultshortname AS result_name,
            COALESCE(base.committeeid, base.personcommitteeid) AS committee_id,
            --base.committeename,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            {{ normalize_timestamp_to_utc('base.datecanvassed') }} AS utc_canvassed_at,
            inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            contacttypeid AS contact_method_type_id,
            contacttypes.contacttypename AS contact_method_type,
            base.username AS canvassed_by_username,
            base.canvassedby AS canvassed_by_user_id,
            base.campaignid AS campaign_id,
            base.contentid AS content_id,
            base.createdby AS created_by_user_id,
            base.contactsphoneid AS contacts_phone_id,
            base.teamid AS team_id,
            base.divisionid AS division_id,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__contactscontacts") }}
            {{ ngpvan__metadata__select_fields(from_cte='base', myvoters=true) }},

            {{ ngpvan__stg__unique_id(columns=['base.segment_by', 'base.statecode', 'base.contactscontactid'], grain='contacts_contact') }},

            CONCAT(base.segment_by, '-', base.contactscontactid) AS segmented_contacts_contact_id,
            CONCAT(base.segment_by, '-', base.vanid) AS segmented_van_id

            {{ ngpvan__stg__additional_fields() }}

        FROM base
        LEFT JOIN results USING (resultid)
        LEFT JOIN inputtypes USING (inputtypeid)
        LEFT JOIN contacttypes USING (contacttypeid)

    )

SELECT DISTINCT * FROM renamed
-- QUALIFY ROW_NUMBER() OVER (PARTITION BY vendor_unique_stg_ngpvan__contacts_contacts_id ORDER BY utc_modified_at DESC NULLS LAST) = 1
