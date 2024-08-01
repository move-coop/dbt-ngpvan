
WITH
    users AS (
        SELECT * FROM {{ ref("stg_ngpvan__users") }}
    ),

    user_groups AS (
        SELECT
            user_id,
            user_group_id,
            user_group_name
        FROM {{ ref("stg_ngpvan__users_user_groups") }}
    ),

    public_users AS (
        SELECT
            public_user_id,
            public_username,
            van_id AS public_user_van_id,
            committee_id AS public_user_committee_id,
            _dbt_source_relation,
            source_schema,
            source_table,
            segment_by
        FROM {{ ref("stg_ngpvan__public_users") }}
    ),

    joined AS (
        SELECT
            users.user_id,
            users.username,
            CASE WHEN public_users.public_user_id IS NOT NULL
                    THEN TRUE
                    ELSE FALSE
                END AS is_public_user,
            public_users.public_user_id,
            public_username,
            users.first_name,
            users.last_name,
            users.address_line_1,
            users.city,
            users.state,
            users.zip_code,
            users.email_address,
            users.home_phone,
            users.cell_phone,
            user_groups.user_group_id,
            user_groups.user_group_name,
            public_users.public_user_van_id,
            public_users.public_user_committee_id,
            COALESCE(users._dbt_source_relation, public_users._dbt_source_relation) AS _dbt_source_relation,
            COALESCE(users.source_schema, public_users.source_schema) AS source_schema,
            COALESCE(users.source_table, public_users.source_table) AS source_table,
            COALESCE(users.segment_by, public_users.segment_by) AS segment_by
            {{- ngpvan__int__additional_fields() }}

        FROM users
        LEFT JOIN user_groups USING (user_id)
        FULL OUTER JOIN public_users USING (public_username)
    )

SELECT * FROM joined