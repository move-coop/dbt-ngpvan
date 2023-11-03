{%- macro ngpvan__stg__additional_fields() -%}

    ,
    '{{ var("dbt_ngpvan_config")["vendor_name"] }}' AS vendor

{%- endmacro %}