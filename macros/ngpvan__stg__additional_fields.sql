{%- macro ngpvan__stg__additional_fields(columns, grain) -%}
    {{ return(adapter.dispatch('ngpvan__stg__additional_fields', 'dbt_ngpvan')(columns, grain)) }}
{%- endmacro %}

{%- macro default__ngpvan__stg__additional_fields(columns, grain) -%}
    ,
    '{{ var("dbt_ngpvan_config")["vendor_name"] }}' AS vendor,
    {{ ngpvan__stg__unique_id(columns=columns, grain=grain) }}


{%- endmacro %}