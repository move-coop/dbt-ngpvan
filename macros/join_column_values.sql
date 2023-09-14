{%- macro join_column_values(list_of_columns, delimiter="\' \'") -%}
    NULLIF(
        -- Add columns to coalesce evaluation
        {% for column in list_of_columns %}
            {% if not loop.last %}
                COALESCE({{ column }} || {{ delimiter }}, '') || 
            {% else %}
                COALESCE({{ column }} || {{ delimiter }}, '')
            {% endif %}
        {% endfor %},
            
        -- Default case will return null
        ''
        )
        
{%- endmacro -%}