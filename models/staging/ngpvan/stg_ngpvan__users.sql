
{{
    config(
        alias='stg_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__users'
    )
}}

WITH
    base AS (
        SELECT * FROM {{ ref('base_ngpvan__users') }}
    ),

    renamed AS (
        SELECT

            userid AS user_id,
            username AS username,
            INITCAP(firstname) AS first_name,
            INITCAP(lastname) AS last_name,
            INITCAP(canvassername) AS public_username,
            address1 AS address_line_1,
            city AS city,
            state,
            zip AS zip_code,
            {{ normalize_email_address('email') }} AS email_address,
            {{ normalize_phone_number('homephone') }} AS home_phone,
            {{ normalize_phone_number('cellphone') }} AS cell_phone,

            -- additional columns
            {{ ngpvan__metadata__select_fields(from_cte='base') }}

        FROM base
    )

SELECT
    *
FROM renamed

