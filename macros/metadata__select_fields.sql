{% macro metadata__select_fields(from_cte=none, myvoters=false) -%}

    {%- set prefix = cte ~ '.' if cte else none -%}

    {{ prefix }}_dbt_source_relation,
    {{ prefix }}source_schema,
    {{ prefix }}source_table,
    {%- if myvoters == true %}
    {{ prefix }}database_mode,
    {{ prefix }}is_myvoters,
    {% endif -%}
    {{ prefix }}vendor,
    {{ prefix }}segment_by

{%- endmacro %}