WITH
    av_source AS (
        SELECT
            COUNT(*)
        FROM {{ source('raw_avvan__ngpvan_corrected', 'contactscontacts_vf') }}
    ),

    bonterra_source AS (
        SELECT
            COUNT(*)
        FROM {{ source('raw_bonterra__tmc_corrected', 'contactscontacts_vf') }}
    ),

    sv_source AS (
        SELECT
            COUNT(*)
        FROM  {{ source('raw_svvan__corrected', 'contactscontacts_vf') }}
    ),

    source_aggregate AS (
        SELECT
            (SELECT * FROM av_source) +
            (SELECT * FROM bonterra_source) +
            (SELECT * FROM sv_source)
    ),
    
    dbt_staging AS (
        SELECT
            'stg_ngpvan__contacts_contacts' AS source,
            COUNT(*) AS row_count
        FROM {{ ref("stg_ngpvan__contacts_contacts")}}
    )

SELECT
    source,
    row_count
FROM dbt_staging
WHERE row_count NOT BETWEEN 
    (SELECT * FROM source_aggregate) * 0.985 AND (SELECT * FROM source_aggregate) * 1.015