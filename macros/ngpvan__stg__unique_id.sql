{%- macro ngpvan__stg__unique_id(columns=[], grain=none) -%}
    {{ return(adapter.dispatch('ngpvan__stg__unique_id', 'dbt_ngpvan')(columns, grain)) }}
{%- endmacro %}

{%- macro default__ngpvan__stg__unique_id(columns, grain) -%}

    CONCAT(
    {%- for col in columns -%}
        COALESCE(CAST({{ col }} AS STRING), '0')
        {%- if not loop.last %},
        '-', {% endif -%}
    {%- endfor -%}
    ) AS vendor_unique_stg_ngpvan__{{ grain }}_id

{%- endmacro %}