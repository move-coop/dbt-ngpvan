{%- macro union_source_tables(schema_pattern=none, schema_list=[], schema_exclude_list=[], table_pattern=none, table_list=[], table_exclude_list=[], column_override=none, where=none, database=target.database) -%}

{%- if execute -%}

{%- if schema_list -%}

    {%- call statement('get_tables', fetch_result=True) %}

        {% for schema in schema_list %}
            SELECT DISTINCT
                table_schema,
                table_name

            FROM {{ adapter.quote(database) }}.{{ schema }}.INFORMATION_SCHEMA.TABLES
            WHERE (
                {% if table_pattern %}
                    LOWER(table_name) LIKE LOWER('{{ table_pattern }}')
                        {% if table_list -%} OR {%- endif %}
                {% endif %}
                {% if table_list %}
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
            {%- set tbl_relation = api.Relation.create(
                database=database,
                schema=row.table_schema,
                identifier=row.table_name
            ) -%}

            {%- set relation_exists=relation is not none -%}
                {%- if relation_exists -%}

                    {%- do tbl_relations.append(tbl_relation) -%}
                {%- else -%}
                    {%- if execute -%}
                        {{ log("couldnt find relation " ~ row.table_schema ~ "." ~ row.table_name, info=True) }}
                    {%- endif -%}
                {%- endif -%}

            {%- do tbl_relations.append(tbl_relation) -%}
        {%- endfor -%}

        {%- if not column_override -%}
            {{-  dbt_utils.union_relations(relations) -}}

        {%- else -%}
            {{- dbt_utils.union_relations(relations, column_override=column_override)}}
        {%- endif -%}

    {%- else -%}
        {{ return([]) }}
    {%- endif -%}

{%- endif -%}

{%- endif -%}

{% endmacro %}
