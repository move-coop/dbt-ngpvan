{%- if var("dbt_ngpvan_config")["enable_incremental_models"] -%}

{%- set partitions_to_replace = generate_partitions_to_replace(
        incremental_window=var('dbt_ngpvan_config')["default_incremental_window__days"],
        date_part="day"
    ) 
-%}

{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contactscontacts',
        materialized="incremental",
        partition_by={
            "field": "datecanvassed",
            "data_type": "timestamp",
            "granularity": "day"
        },
        incremental_strategy="insert_overwrite",
        require_partition_filter=false,
        partitions=partitions_to_replace
    )
}}

{%- else -%}
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contactscontacts'
    )
}}

{%- endif -%}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='contactscontacts'
                )
        }}

    )

SELECT
    *,
    {{
        ngpvan__metadata__generate_fields(
            segment_by_column='committeeid',
            myvoters=var('dbt_ngpvan_config')['packages']['myvoters']['enabled']
        )
    }}
FROM base
