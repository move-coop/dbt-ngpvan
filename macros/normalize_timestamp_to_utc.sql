{%- macro normalize_timestamp_to_utc(time_stamp, convert_from_timezone='UTC', convert_to_timezone='UTC') %}

    CASE WHEN {{ time_stamp }} IS NOT NULL AND TRIM(CAST({{ time_stamp }} AS STRING)) != ''

    {% if convert_from_timezone != 'UTC' %}
            THEN FORMAT_TIMESTAMP('%G-%m-%d %H:%M:%S', TIMESTAMP(CAST({{ time_stamp }} AS STRING), '{{ convert_from_timezone }}'), '{{ convert_to_timezone }}' )
    {% else %}
            THEN CAST(FORMAT_TIMESTAMP('%G-%m-%d %H:%M:%S', TIMESTAMP( {{ time_stamp }}), '{{ convert_to_timezone }}' )  AS TIMESTAMP)
    {% endif %}
            ELSE NULL
        END

{%- endmacro -%}