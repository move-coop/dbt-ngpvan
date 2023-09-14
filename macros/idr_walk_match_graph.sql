{%- macro idr_walk_match_graph(matches_table, matches_join_col, direct_root_table, round) -%}

    SELECT
        matches.*,
        best_direct_root.best_direct_root_id AS best_root_id_{{ round }},
        best_direct_root.best_direct_root_created_at AS best_root_created_at_{{ round }}
    FROM {{ matches_table }} matches
    LEFT JOIN {{ direct_root_table }} best_direct_root 
        ON matches.{{ matches_join_col }} = best_direct_root.needs_match_id

{%- endmacro -%}