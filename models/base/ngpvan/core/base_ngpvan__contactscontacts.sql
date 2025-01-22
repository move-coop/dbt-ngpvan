{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__contactscontacts'
    )
}}

{%- if flags.FULL_REFRESH -%}
    {%- set table_pattern="contactscontacts" -%}
{%- else -%}
    {%- set table_pattern="incremental_contacts_contacts" -%}
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
