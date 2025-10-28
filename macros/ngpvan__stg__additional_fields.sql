{%- macro ngpvan__stg__additional_fields() -%}
    {{ return(adapter.dispatch('ngpvan__stg__additional_fields', 'dbt_ngpvan')()) }}
{%- endmacro %}

{%- macro default__ngpvan__stg__additional_fields() -%}
    ,
    '{{ var("dbt_ngpvan_config")["vendor_name"] }}' AS vendor

{%- endmacro %}