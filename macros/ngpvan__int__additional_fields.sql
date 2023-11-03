{%- macro ngpvan__int__additional_fields() -%}

    ,
    '{{ var("dbt_ngpvan_config")["vendor_name"] }}' AS vendor

{%- endmacro %}