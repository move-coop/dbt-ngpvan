{#
    Filters out committees listed in the `committee_exclude_list` key of the
    `dbt_ngpvan_config` var. Accepts either a list of committee IDs or a
    mapping of committee ID -> reason (the reason is logged at compile time).

    If `committee_exclude_schemas` is set, committees are only filtered out of
    rows sourced from those schemas; otherwise they're filtered from all schemas.

    Renders a full WHERE clause, or nothing when the exclusion list is empty.
    Rows with a NULL committee ID are kept.
#}
{%- macro ngpvan__stg__exclude_committees(field_name='committeeid', schema_field='source_schema', exclude_list=none, exclude_schemas=none) -%}
    {{ return(adapter.dispatch('ngpvan__stg__exclude_committees', 'dbt_ngpvan')(field_name, schema_field, exclude_list, exclude_schemas)) }}
{%- endmacro %}

{%- macro default__ngpvan__stg__exclude_committees(field_name, schema_field, exclude_list, exclude_schemas) -%}

    {%- set config = var('dbt_ngpvan_config') -%}

    {%- if exclude_list is none -%}
        {%- set exclude_list = config.get('committee_exclude_list', []) -%}
    {%- endif -%}

    {%- if exclude_schemas is none -%}
        {%- set exclude_schemas = config.get('committee_exclude_schemas', []) -%}
    {%- endif -%}

    {%- if exclude_list | length > 0 -%}

        {%- if execute -%}
            {%- set schema_note = " (schemas: " ~ exclude_schemas | join(', ') ~ ")" if exclude_schemas else "" -%}
            {%- for committee_id in exclude_list -%}
                {%- set reason = exclude_list[committee_id] if exclude_list is mapping else none -%}
                {%- do log("⚠️ Suppressing committee " ~ committee_id ~ " from " ~ model.name ~ schema_note ~ (": " ~ reason if reason else ""), info=true) -%}
            {%- endfor -%}
        {%- endif %}

        WHERE (
            {{ field_name }} IS NULL
            OR {{ field_name }} NOT IN ({{ exclude_list | map('string') | join(', ') }})
            {%- if exclude_schemas %}
            OR LOWER({{ schema_field }}) NOT IN ({% for schema in exclude_schemas %}LOWER('{{ schema }}'){% if not loop.last %}, {% endif %}{% endfor %})
            {%- endif %}
        )

    {%- endif -%}

{%- endmacro %}
