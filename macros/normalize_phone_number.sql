{% macro normalize_phone_number(phone_number) -%}
     CASE WHEN LENGTH(RIGHT(REGEXP_REPLACE({{ phone_number }}, '[^0-9]', ''), 10)) = 10 -- Make sure the number is long enough
               AND LEFT(RIGHT(REGEXP_REPLACE({{ phone_number }}, '[^0-9]', ''), 10), 1) NOT IN ('1', '0') -- Make sure it doesn't start with a 0 or 1
               AND RIGHT(REGEXP_REPLACE({{ phone_number }}, '[^0-9]', ''), 10) <> '9999999999' -- Make sure it isn't all 9's
          THEN RIGHT(REGEXP_REPLACE({{ phone_number }}, '[^0-9]', ''), 10) -- Go!
          ELSE NULL END
{%- endmacro %}

