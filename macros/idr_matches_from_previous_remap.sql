{%- macro idr_matches_from_previous_remap(from_remap_number) -%}

    WITH previous_remap as (
        SELECT
            remap.needs_match_id,
            remap.needs_match_created_at,
            remap.root_id,
            remap.root_created_at,
            remap.match_score,
            remap.best_root_id_overall AS best_root_id_overall__{{ from_remap_number }},
            remap.best_root_created_at_overall AS best_root_created_at_overall__{{ from_remap_number }}
        FROM {{ ref('match_remap__' + from_remap_number) }} remap
    ), all_indirect_matches as (
        SELECT
            DISTINCT
            root_id AS needs_match_id,
            root_created_at AS needs_match_created_at,
            best_root_id_overall__{{ from_remap_number }} AS root_id,
            best_root_created_at_overall__{{ from_remap_number }} AS root_created_at,
            CAST(NULL AS FLOAT) AS match_score,
            best_root_id_overall__{{ from_remap_number }},
            best_root_created_at_overall__{{ from_remap_number }}
        FROM previous_remap
        WHERE best_root_created_at_overall__{{ from_remap_number }} < root_created_at
    ), new_indirect_matches as (
        SELECT all_indirect_matches.*
        FROM all_indirect_matches
        LEFT JOIN previous_remap using (needs_match_id, root_id)
        WHERE previous_remap.needs_match_id is null and previous_remap.root_id IS NULL
    )
    SELECT * FROM previous_remap
    UNION
    SELECT * FROM new_indirect_matches


{%- endmacro -%}