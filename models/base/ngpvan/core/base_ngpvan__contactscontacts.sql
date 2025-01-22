{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contactscontacts'
    )
}}

{%- if var("dbt_ngpvan_config")["enable_incremental_models"] and not is_incremental() -%}
    {{ print("Building contacts_contacts incrementally...") }}
    {%- set table_pattern="incremental_contacts_contacts" -%}
{%- else -%}
    {%- set table_pattern="contactscontacts" -%}
{%- endif -%}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern=table_pattern
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
