
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactscodes') }}
    ),

    inputtypes AS (
        SELECT * FROM {{ ref('base_ngpvan__inputtypes') }}
    ),

    renamed AS (
        SELECT
            base.statecode AS van_state_code,
            base.contactscodeid AS contacts_code_id,
            base.vanid AS van_id,
            base.codeid AS code_id,
            base.committeeid AS committee_id,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            base.inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,
            base.createdby AS created_by_user_id,

            {{ ngpvan__metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(base.segment_by, '-', base.contactscodeid) AS segmented_contacts_code_id,
            CONCAT(base.segment_by, '-', base.vanid) AS segmented_van_id
            {{ ngpvan__stg__additional_fields() }}

        FROM base
        LEFT JOIN inputtypes USING (inputtypeid)
    )

SELECT
    *
FROM renamed

