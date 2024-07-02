-- This macro provides support for additional fields that the user wishes
-- to pull through the `dbt-ngpvan` pipeline from their own workflow (for instance,
-- additional fields provided by a vendor)

{%- macro ngpvan__user__additional_fields(base_ref) -%}
    {{ return(adapter.dispatch('ngpvan__user__additional_fields', 'dbt_ngpvan')(base_ref=base_ref)) }}
{%- endmacro %}

{%- macro default__ngpvan__user__additional_fields(base_ref) -%}
    {%- if var("dbt_ngpvan_config")["additional_fields"] -%}
        {%- set columns = dbt_utils.get_filtered_columns_in_relation(from=ref(base_ref)) -%}
        {%- for field in var("dbt_ngpvan_config")["additional_fields"] -%}
            
            {%- if field in columns -%}
                , {{ field }}
            {%- else -%}
                , NULL AS {{ field }}
            {%- endif -%}

        {%- endfor -%}
    {%- endif -%}

{%- endmacro %}