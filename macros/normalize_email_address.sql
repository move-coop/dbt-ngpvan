{% macro normalize_email_address(email_address) -%}

    -- Make sure email is not blank
    CASE WHEN LENGTH(LOWER(TRIM( {{ email_address }} ))) > 3

    -- Check email validity (slightly different code for different adapters)
    {% if target.type == 'redshift' %}
        AND REGEXP_SUBSTR(LOWER(TRIM( {{ email_address }} )), '^[a-z0-9][\\.\\w\\+\\-]*[a-z0-9\\_]*@[a-z0-9][\\.\\w\\-]*\\.\\w+[a-z0-9]$', 1, 'p') IS NOT NULL

    {% elif target.type == 'bigquery' %}
        AND REGEXP_SUBSTR(LOWER(TRIM( {{ email_address }} )), r'^[a-z0-9][\.\w\+\-]*[a-z0-9\_]*@[a-z0-9][\.\w\-]*\.\w+[a-z0-9]$', 1) IS NOT NULL

    {% endif %}

    THEN LOWER(TRIM( {{ email_address }} ))
    ELSE NULL END

{%- endmacro %}