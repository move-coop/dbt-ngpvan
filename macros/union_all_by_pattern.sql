{% macro union_all_by_pattern(schema_pattern='%\_ak', table_pattern='core_user') -%}

{%- set matching_relations = dbt_utils.get_relations_by_pattern(
    schema_pattern=schema_pattern,
    table_pattern=table_pattern
) -%}

{%- for relation in matching_relations -%}

    {% set source_exists = source(relation.schema, relation.identifier) is not none %}
\
    {%- if source_exists -%}

        {{ print('hi') }}

    {%- endif -%}

{%- endfor -%}

{{ dbt_utils.union_relations(matching_relations) }}

{%- endmacro %}
