{%- macro idr_best_direct_root(table, from_remap_number) -%}

    SELECT DISTINCT
        needs_match_id,
        FIRST_VALUE(best_root_id_overall__{{ from_remap_number }}) OVER (
            PARTITION BY needs_match_id 
            ORDER BY 
                best_root_created_at_overall__{{ from_remap_number }} ASC NULLS LAST, 
                best_root_id_overall__{{ from_remap_number }} ASC NULLS LAST
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS best_direct_root_id,
        FIRST_VALUE(best_root_created_at_overall__{{ from_remap_number }}) OVER (
            PARTITION BY needs_match_id 
            ORDER BY 
                best_root_created_at_overall__{{ from_remap_number }} ASC NULLS LAST,
                best_root_id_overall__{{ from_remap_number }} ASC NULLS LAST
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS best_direct_root_created_at
    FROM {{ table }}

{%- endmacro -%}