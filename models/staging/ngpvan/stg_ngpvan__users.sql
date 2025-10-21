
WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__users') }}
    ),

    renamed AS (
        SELECT

            userid AS user_id,
            username AS username,
            TRIM(INITCAP(firstname)) AS first_name,
            TRIM(INITCAP(lastname)) AS last_name,
            TRIM(INITCAP(canvassername)) AS public_username,
            address1 AS address_line_1,
            city AS city,
            state,
            zip AS zip_code,
            {{ normalize_email_address('email') }} AS email_address,
            {{ normalize_phone_number('homephone') }} AS home_phone,
            {{ normalize_phone_number('cellphone') }} AS cell_phone,

            -- additional columns
            {{ ngpvan__user__additional_fields("base_ngpvan__users") }}
            {{ ngpvan__metadata__select_fields(from_cte='base') }}
            {{ ngpvan__stg__additional_fields() }},
            {{ ngpvan__stg__unique_id(columns=['base.segment_by', 'base.userid'], grain='user') }}

        FROM base
    ),

    dedupe AS (
        SELECT
            DISTINCT
            user_id,
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
            STRING_AGG(_avvan_source_relation) AS _avvan_source_relation,
            STRING_AGG(_dbt_source_relation) AS _dbt_source_relation,
            STRING_AGG(source_schema) AS source_schema,
            STRING_AGG(source_table) AS source_table,
            segment_by,
            vendor,
            vendor_unique_stg_ngpvan__user_id
        FROM renamed
        GROUP BY ALL
    )

SELECT
    *
FROM dedupe

