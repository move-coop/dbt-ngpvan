
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__contactsnotes') }}
    ),

    renamed AS (
        SELECT
            statecode AS van_state_code,
            contactsnoteid AS contacts_note_id,
            vanid AS van_id,
            createdby AS created_by_user_id,
            {{ normalize_timestamp_to_utc('datecreated') }} AS utc_created_at,
            committeeid AS committee_id,
            suppressedby AS suppressed_by_user_id,
            {{ normalize_timestamp_to_utc('datesuppressed') }} AS utc_suppressed_at,
            notetext AS note_text,
            datefollowup,
            followupcompletedby AS followup_completed_by_user_id,
            datefollowupcompleted,
            contactscontactid AS contacts_contact_id,
            {{ normalize_timestamp_to_utc('datemodified') }} AS utc_modified_at,
            notecategoryname AS note_category,
            contactsonlineformid AS contacts_online_form_id,
            contactsstoryid AS contacts_story_id,
            notecategoryid AS note_category_id,

            -- additional columns
            {{ metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(segment_by, '-', contactsnoteid) AS segmented_contacts_note_id,
            CONCAT(segment_by, '-', vanid) AS segmented_van_id

        FROM base
    )

SELECT
    *
FROM renamed

