{%- macro ap_refresh_ids(crosswalk_table, ap_table) -%}

    WITH
        crosswalk AS (
            SELECT
                *
            FROM {{ crosswalk_table }}
            WHERE last_idr_run_at >= COALESCE((SELECT MAX(last_idr_run_at) FROM {{ ref('cdp_activistpools__' ~ ap_table) }}), '2000-01-01 00:00:00')
        )

    UPDATE {{ ref('cdp_activistpools__' ~ ap_table) }}
    SET tmc_person_id = crosswalk.tmc_person_id,
        last_idr_run_at = crosswalk.last_idr_run_at
        {% if ap_table == 'users' -%},
            tmc_person_first_created_at = crosswalk.tmc_person_first_created_at
        {% endif %}
    FROM crosswalk
    WHERE {{ ref('cdp_activistpools__' ~ ap_table) }}.member_unique_user_id = crosswalk.member_unique_user_id

{%- endmacro -%}