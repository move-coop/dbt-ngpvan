WITH base AS (

    
    

        (
            select
                cast('"dev"."tmc_van"."tsm_tmc_codetypes"' as TEXT) as _dbt_source_relation,

                
                    cast("codetypeid" as smallint) as "codetypeid" ,
                    cast("codetypename" as character varying(300)) as "codetypename" 

            from "dev"."tmc_van"."tsm_tmc_codetypes"

            
        )

        

)

, segment_by AS (

    SELECT
        *,
        NULL::int as committeeid

    FROM base
)


SELECT 
    *,
    SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 2) AS source_schema,
    SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 3) AS source_table,
    'van' AS vendor,
    committeeid AS segment_by,
    md5(cast(coalesce(cast('van' as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(committeeid as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(codetypeid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS vendor_unique_codetypes_id
FROM segment_by