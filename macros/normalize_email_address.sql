{% macro normalize_email_address(email_address) -%}

    CASE WHEN LENGTH(LOWER(TRIM( {{ email_address }} ))) > 3 -- Make sure it's not blank
        AND REGEXP_COUNT(LOWER(TRIM( {{ email_address }} )), '^[a-z0-9][\\.\\w\\+\\-]*[a-z0-9\\_]*@[a-z0-9][\\.\\w\\-]*\\.\\w+[a-z0-9]$', 1, 'p') = 1 -- Make sure it's a valid email address
    THEN LOWER(TRIM( {{ email_address }} ))
    ELSE NULL END
{%- endmacro %}