{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if 'schema_override' in node.tags and custom_schema_name is not none -%}

        {{ custom_schema_name | trim }}

     {%- elif target.name == 'dev' and custom_schema_name is not none -%}

        {{ default_schema }}_dev

    {%- elif target.name == 'prod' and custom_schema_name is not none -%}

        {{ custom_schema_name | trim }}

    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro -%}