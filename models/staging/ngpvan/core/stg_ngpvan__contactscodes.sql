
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactscodes') }}
    ),

    committees AS (
        SELECT * FROM {{ ref('base_ngpvan__committees') }}
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
            committees.committeename AS committee_name,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            base.inputtypeid AS input_type_id,
            inputtypes.inputtypename AS input_type,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,
            base.createdby AS created_by_user_id,

            {{ metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(base.segment_by, '-', base.contactscodeid) AS segmented_contacts_code_id,
            CONCAT(segment_by, '-', vanid) AS segmented_van_id

        FROM base
        LEFT JOIN committees USING (committeeid)
        LEFT JOIN inputtypes USING (inputtypeid)
    )

SELECT
    *
FROM renamed

