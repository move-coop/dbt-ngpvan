{%- macro normalize_timestamp_to_utc(time_stamp, time_zone='UTC') -%}

{#- This looks a little wacky because we want to accommodate just about any input we might come across - e.g. if a timestamp has a timezone but is of VARCHAR type, and we cast it straight to a TIMESTAMP we lose the timezone (Actblue for example: 2023-05-09T11:49:03-04:00) -#}

    CASE
        WHEN {{ time_stamp }} IS NOT NULL AND TRIM( {{ time_stamp }} ) != ''
        THEN CONVERT_TIMEZONE('{{ time_zone }}', 'UTC', DATE_TRUNC('second', CAST(CAST( {{ time_stamp }} AS TIMESTAMP WITH TIME ZONE) AS TIMESTAMP)))
        ELSE NULL
    END

{%- endmacro -%}