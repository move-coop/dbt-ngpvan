{% macro generate_partitions_to_replace(incremental_window, date_part) %}

    {%- set partitions_to_replace = [] -%}
    {%- for i in range(incremental_window|int + 1) -%}
    {{ partitions_to_replace.append(
        'timestamp_trunc(timestamp(date_sub(current_date, interval ' + i|string + ' ' + date_part + ')), ' + date_part + ')'
    )}}
    {%- endfor -%}

    {%- do return(partitions_to_replace) -%}

{% endmacro %}