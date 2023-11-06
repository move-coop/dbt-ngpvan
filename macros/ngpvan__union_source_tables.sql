{%- macro ngpvan__union_source_tables(schema_list=var('dbt_ngpvan_config')['schema_list'], table_pattern=none) -%}
    {{ return(adapter.dispatch('ngpvan__union_source_tables', 'dbt_ngpvan')(schema_list, table_pattern)) }}
{%- endmacro %}


{%- macro default__ngpvan__union_source_tables(schema_list, table_pattern) -%}

{%- if execute -%}

{# {{ log("table_pattern: " ~ table_pattern, info=True) }} #}

{%- set config = var('dbt_ngpvan_config') -%}

{%- set database = config.source_database or target.database -%}

{%- set schema_list = config['schema_list'] -%}

{%- if schema_list -%}

    {%- call statement('get_tables', fetch_result=True) %}

        {% for schema in schema_list %}
            SELECT DISTINCT
                table_schema,
                table_name

            FROM {{ adapter.quote(database) }}.{{ schema }}.INFORMATION_SCHEMA.TABLES
            WHERE (
                {% if config['table_logic'] == 'pattern' %}
                    REGEXP_SUBSTR(LOWER(table_name), r'(?:^|^[\w]+_)({{ table_pattern }}){1}(?:$|_[\w]+$)', 1) != ''

                {% elif config['table_logic'] == 'list' %}

                    {% for include_table in table_list %}
                        LOWER(table_name) = LOWER('{{ include_table }}')
                            {% if not loop.last -%} OR {%- endif %}
                    {% endfor %}
                    {% if table_exclude_list -%} AND {%- endif %}

                {% endif %}
            )
                {% if table_exclude_list %}
                    {% for exclude_table in table_exclude_list %}
                        LOWER(table_name) != LOWER('{{ exclude_table }}')
                        {% if not loop.last -%} AND {%- endif %}
                    {% endfor %}
                {% endif %}

            {% if not loop.last %} UNION ALL {% endif %}

        {% endfor %}

    {% endcall %}

    {%- set table_list = load_result('get_tables') -%}
    {# {{ log("table_list: " ~ table_list, info=True) }} #}

    {%- if table_list and table_list['table'] -%}
        {%- set tbl_relations = [] -%}
        {%- for row in table_list['table'] -%}
            {# {{ log("row: " ~ row, info=True) }} #}
            {%- set relation = adapter.get_relation(
                database=database,
                schema=row.table_schema,
                identifier=row.table_name
            ) -%}

            {%- set relation_exists=relation is not none -%}
                {%- if relation_exists -%}

                    {%- do tbl_relations.append(relation) -%}
                    {# {{ log("tbl_relations: " ~ tbl_relations, info=True) }} #}
                {%- else -%}
                    {%- if execute -%}
                        {{ log("couldnt find relation " ~ row.table_schema ~ "." ~ row.table_name, info=True) }}
                    {%- endif -%}
                {%- endif -%}

        {%- endfor -%}

        {%- if not column_override -%}
            {{-  dbt_utils.union_relations(tbl_relations) -}}

        {%- else -%}
            {{- dbt_utils.union_relations(tbl_relations, column_override=column_override)}}
        {%- endif -%}

    {%- else -%}
        {{ return('SELECT NULL AS no_sources') }}
    {%- endif -%}

{# if schema_list is missing #}
{%- else -%}
{{ log("No schema list defined. Please add schema(s) to dbt_ngpvan_config variable in your project file.", info=True) }}
{%- endif -%}

{%- endif -%}

{% endmacro %}
