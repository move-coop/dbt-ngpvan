{% macro source_dependency_check(source_name, table_name) -%}

    {%- set database=source(source_name, table_name).database -%}
    {%- set schema=source(source_name, table_name).schema -%}
    {%- set identifier=source(source_name, table_name).name -%}

    {%- set source_relation = adapter.get_relation(
        database=database,
        schema=schema,
        identifier=identifier
    ) -%}

    {% set table_exists=source_relation is not none %}

    {% if table_exists %}

        {{ log("[Debug] Source table "~schema~"."~identifier~" exists", debug=True) }}

        true

    {% else %}

        {{ log("[Debug] Source table "~schema~"."~identifier~" does not exist", debug=True) }}

        false

    {% endif %}

{%- endmacro %}
