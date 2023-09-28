{% macro normalize_zip_code(zip_code_column, get_zip_four=false) %}
    -- Looking for five digit zip
    {% if not get_zip_four %}
        SPLIT_PART(
            COALESCE(NULLIF({{ zip_code_column }}, ' '), ''), 
            '-', 
            1)

    -- Looking for four digit extension
    {% else %}
        SPLIT_PART({{ zip_code_column }}, '-', 2)
    
    {% endif %}

{% endmacro %}

-- Dep'd for now
-- {% macro normalize_zip_code__dep(default_zip, zip_four=none, prefix=none) %}
--     {% if prefix %}
--     {% set zip_5_name = prefix~"_zip_5" %}
--     {% set zip_4_name = prefix~"_zip_4" %}
    
--     {% else %}
--     {% set zip_5_name = "zip_5" %}
--     {% set zip_4_name = "zip_4" %}

--     {% endif %}

--     CASE
--         WHEN NULLIF({{ default_zip }}, '') IS NULL THEN NULL
--         ELSE SPLIT_PART({{default_zip}}, '-', 1)
--     END AS {{ zip_5_name }}

--     {% if zip_four %}
--     , COALESCE(
--         zip_four,
--         NULLIF(SPLIT_PART({{default_zip}}, '-', 2), '')
--     ) 
    
--     {% else %}
--     NULLIF(SPLIT_PART({{default_zip}}, '-', 2), '')

--     {% endif %}
--     AS {{ zip_4_name }}
-- {% endmacro %}