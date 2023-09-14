{% macro normalize_country_code(country) -%}

    CASE
        WHEN TRIM(UPPER({{ country }})) IN ('US', 'UNITED STATES') THEN 'US'
        WHEN TRIM(UPPER({{ country }})) IN ('CA', 'CANADA') THEN 'CA'
        ELSE NULL
    END
{%- endmacro %}