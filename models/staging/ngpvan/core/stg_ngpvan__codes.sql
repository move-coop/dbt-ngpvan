
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__codes') }}
    ),

    committees AS (
        SELECT * FROM {{ ref('base_ngpvan__committees') }}
    ),

    codetypes AS (
        SELECT * FROM {{ ref('base_ngpvan__codetypes') }}
    ),

    renamed AS (
        SELECT
            base.statecode AS van_state_code,
            base.codeid AS code_id,
            base.codename AS code_name,
            base.committeeid AS committee_id,
            committees.committeename AS committee_name,
            base.isactive AS active_status_id,
            base.parentcodeid AS parent_code_id,
            base.createdby AS created_by_user_id,
            {{ normalize_timestamp_to_utc('base.datecreated') }} AS utc_created_at,
            base.staticfullname AS static_full_name,
            base.codetypeid AS code_type_id,
            codetypes.codetypename AS code_type,
            {{ normalize_timestamp_to_utc('base.datemodified') }} AS utc_modified_at,

            {{ ngpvan__metadata__select_fields(from_cte='base', myvoters=true) }},
            CONCAT(base.segment_by, '-', base.codeid) AS segmented_code_id

        FROM base
        LEFT JOIN committees USING (committeeid)
        LEFT JOIN codetypes USING (codetypeid)
    )

SELECT
    *
FROM renamed

