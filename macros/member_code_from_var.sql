{%- macro member_code_from_var(vendor_col, segment_by_col) -%}
    {%- if execute -%}

        {%- set vendors = var('vendors') -%}
        CASE
        {%- for vendor in vendors %}
            {% for source in vendors[vendor] -%}
            WHEN {{ vendor_col }} = '{{ vendor }}' AND {{ segment_by_col }} = '{{ source.schema }}'
                    THEN {% if source.member_code == NULL %}NULL
                    {%- else %}UPPER('{{ source.member_code }}'){%- endif %}
            {% endfor %}
        {%- endfor %}
                    ELSE NULL
                END
    {%- endif -%}

{%- endmacro -%}