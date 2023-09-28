{%- macro union_all_by_var(source_variable, default_source_table, source_tables_variable=none, column_override=none) -%}
{# {%- if execute -%} #}

    {%- set sources = var('vendors') -%}

    {%- if (source_variable in sources, none) -%}

        {%- set relations = [] -%}

        {# if there is a var, use var, otherwise use default #}
        {%- for source_schema in sources[source_variable] -%}

            {%- set schema_name = source_schema.schema -%}
            {%- if source_tables_variable -%}
                {%- set tables = source_schema['tables'][source_tables_variable] -%}
            {%- else -%}
                {%- set tables = [default_source_table] -%}
            {%- endif -%}

            {%- for table in tables -%}
                {%- if source_tables_variable and table['name'] -%}
                    {%- set table_name = table['name'] -%}
                {%- else -%}
                    {%- set table_name = table -%}
                {%- endif -%}

                {%- set database=source(schema_name, table_name).database -%}
                {%- set schema=source(schema_name, table_name).schema -%}
                {%- set identifier=source(schema_name, table_name).identifier -%}

                {%- set relation=adapter.get_relation(
                    database=database,
                    schema=schema,
                    identifier=identifier
                ) -%}

                {%- set relation_exists=relation is not none -%}

                {%- if relation_exists -%}
                    {%- do relations.append(relation) -%}
                {%- else -%}
                    {%- if execute -%}
                        {{ log("couldnt find relation " ~ schema ~ "." ~ identifier, info=True) }}
                    {%- endif -%}
                {%- endif -%}

            {%- endfor -%}

        {%- endfor -%}

        {%- if not column_override -%}
        {{-  dbt_utils.union_relations(relations) -}}

        {%- else -%}
        {{- dbt_utils.union_relations(relations, column_override=column_override)}}
        {%- endif -%}

    {%- endif -%}
{# {%- endif -%} #}
{%- endmacro -%}