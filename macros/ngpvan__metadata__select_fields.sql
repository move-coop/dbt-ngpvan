{% macro ngpvan__metadata__select_fields(from_cte=none, myvoters=false, segment_by=none) -%}
    {{ return(adapter.dispatch('ngpvan__metadata__select_fields', 'dbt_ngpvan')(from_cte, myvoters, segment_by)) }}
{%- endmacro %}


{% macro default__ngpvan__metadata__select_fields(from_cte, myvoters, segment_by) -%}
    {%- set prefix = from_cte ~ '.' if from_cte else '' -%}

    {{ prefix }}_dbt_source_relation,
    {{ prefix }}source_schema,
    {{ prefix }}source_table,
    {% if myvoters == true -%}
    {{ prefix }}database_mode,
    {{ prefix }}is_myvoters,
    {%- endif %}
    {% if segment_by -%}
        {{ segment_by }}
    {%- else -%}
        {{ prefix }}segment_by
    {%- endif -%}

{%- endmacro %}