{% macro convert_numbool_to_bool(boolean_field) -%}
    CAST({{ boolean_field }} AS BOOLEAN)
{%- endmacro %}

