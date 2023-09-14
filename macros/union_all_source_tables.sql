{%- macro union_all_source_tables(source_name, source_table_name) -%}

    {%- call statement('get_tables', fetch_result=True) -%}
        SELECT distinct
            table_schema,
            table_name
        FROM INFORMATION_SCHEMA.TABLES
        WHERE table_schema ilike '%_{{ source_name }}%'
            AND (REGEXP_COUNT(table_name, '^[a-z1-9]*(?<!test)_{0,2}{{ source_table_name }}$', 1, 'p') = 1
            OR table_name IN ('{{ source_table_name }}'+'_wfpower', '{{ source_table_name }}_coord'))
        ORDER BY 1,2
        limit 5
    {%- endcall -%}

    {%- set table_list = load_result('get_tables') -%}

    {%- if table_list and table_list['table'] -%}
        {%- set tbl_relations = [] -%}
        {%- for row in table_list['table'] -%}

            {% set database=source(row.table_schema, row.table_name).database %}
            {% set schema=source(row.table_schema, row.table_name).schema %}
            {% set identifier=source(row.table_schema, row.table_name).identifier %}

            {%- set tbl_relation = adapter.get_relation(
                database=database,
                schema=schema,
                identifier=identifier
            ) -%}

            {{ print('tbl_relation:') }}
            {{ print(tbl_relation) }}
            {{ print(tbl_relation.get('metadata', {}).get('type', '')) }}
            {%- do tbl_relations.append(tbl_relation) -%}
        {%- endfor -%}
    {%- else -%}
        {{ return([]) }}
    {%- endif -%}

    {%- set sources = [] -%}

    {%- for relation in tbl_relations -%}
        {% set source_exists = source(relation.schema, relation.identifier) is not none %}
        {{ print(source(relation.schema, relation.identifier)) }}
        {{ print(source(relation.schema, relation.identifier).get('metadata', {}).get('type', '')) }}
        {%- if source_exists -%}
            {% do sources.append(source(relation.schema, relation.identifier)) %}
            {{ print('Good to go') }}
        {%- endif -%}
    {%- endfor -%} 

    {{ dbt_utils.union_relations(sources) }}

{%- endmacro -%}