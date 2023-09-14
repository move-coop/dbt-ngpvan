{% macro staging_metadata_fields(vendor, segment_by_column, segment_primary_keys) -%}
    
    {%- set surrogate_key_cols = ["'" ~ vendor ~ "'", segment_by_column] -%}

    {%- for primary_key in segment_primary_keys -%}

        {%- do surrogate_key_cols.append(primary_key) -%}

    {%- endfor -%}

    {%- set table_name_parts = this.identifier.split('__') -%}

    SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 2) AS source_schema,
    SPLIT_PART(REPLACE(_dbt_source_relation, '"', ''), '.', 3) AS source_table,
    '{{ vendor }}' AS vendor,
    {{ segment_by_column }} AS segment_by,
    {{ dbt_utils.generate_surrogate_key(surrogate_key_cols) }} AS vendor_unique_{{ table_name_parts[1] }}_id

{%- endmacro %}