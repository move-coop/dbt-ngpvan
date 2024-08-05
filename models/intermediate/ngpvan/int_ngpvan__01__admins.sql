
WITH
    users AS (
        SELECT 
            user_id,
            NULL AS public_user_id,
            username,
            first_name,
            last_name,
            public_username,
            address_line_1,
            city,
            state,
            zip_code,
            email_address,
            home_phone,
            cell_phone,
            NULL AS public_user_van_id,
            NULL AS public_user_committee_id,
            CAST(NULL AS TIMESTAMP) AS public_user_created_at,
            _dbt_source_relation,
            source_schema,
            source_table,
            segment_by
        FROM {{ ref("stg_ngpvan__users") }}
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
            public_user_id AS user_id,
            public_user_id,
            CAST(NULL AS STRING) AS username,
            CAST(NULL AS STRING) AS first_name,
            CAST(NULL AS STRING) AS last_name,
            public_username,
            CAST(NULL AS STRING) AS address_line_1,
            CAST(NULL AS STRING) AS city,
            CAST(NULL AS STRING) AS state,
            CAST(NULL AS STRING) AS zip_code,
            CAST(NULL AS STRING) AS email_address,
            CAST(NULL AS STRING) AS home_phone,
            CAST(NULL AS STRING) AS cell_phone,
            van_id AS public_user_van_id,
            committee_id AS public_user_committee_id,
            created_at AS public_user_created_at,
            _dbt_source_relation,
            source_schema,
            source_table,
            segment_by
        FROM {{ ref("stg_ngpvan__public_users") }}
    ),

    all_users AS (
        SELECT * FROM users
        UNION DISTINCT
        SELECT * FROM public_users
    ),

    joined AS (
        SELECT
            users.user_id,
            users.username,
            CASE WHEN users.public_user_id IS NOT NULL
                    THEN TRUE
                    ELSE FALSE
                END AS is_public_user,
            users.public_user_id,
            users.public_username,
            users.first_name,
            users.last_name,
            users.address_line_1,
            users.city,
            users.state,
            users.zip_code,
            users.email_address,
            users.home_phone,
            users.cell_phone,
            users.public_user_van_id,
            users.public_user_committee_id,
            users.public_user_created_at,
            users.segment_by,
            ARRAY_AGG(DISTINCT user_groups.user_group_id IGNORE NULLS) as user_group_ids,
            ARRAY_AGG(DISTINCT user_groups.user_group_name IGNORE NULLS) as user_group_names,
            MAX(users._dbt_source_relation) AS _dbt_source_relation,
            MAX(users.source_schema) AS source_schema,
            MAX(users.source_table) AS source_table
            {{- ngpvan__int__additional_fields() }}

        FROM users
        LEFT JOIN user_groups USING (user_id) 
        GROUP BY           
            users.user_id,
            users.username,
            users.public_user_id,
            users.public_username,
            users.first_name,
            users.last_name,
            users.address_line_1,
            users.city,
            users.state,
            users.zip_code,
            users.email_address,
            users.home_phone,
            users.cell_phone,
            users.public_user_van_id,
            users.public_user_committee_id,
            users.public_user_created_at,
            users.segment_by
    )

SELECT * FROM joined