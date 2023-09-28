# dbt-van
an open source repository for applying dbt to ngpvan pipeline data

## What is Included
This package currently only includes voterfile side data.

## Layers
#### Raw
- Function:
    - Keep data as close to raw as possible
    - Single source of truth for data. All downstream data models could be recreated off of the raw.
    - Separates Extract and Load logic from Tranformation logic explicitly
- Schema: raw_van__{pipeline}
- Default Materialization: table
- Types of Transformations:
    - None
- Metadata Added:
    -
- Testing Approach:
    - None

#### Base
- Function:
    - Prep layer for staging primarily for the purpose of unioning data across pipelines into a common table
    (this is helpful for folks who may be unioning mulitiple pipelines)
    - This greatly simplifies the logic in the staging layer
- Schema: dbt_base
- Table Names: base_van__{table}
- Default Materialization: table
- Types of Transformations:
    - Union together common data
    - rename committee id columns to `committeeid`
- Metadata Added:
    - Source schema and table
    -
- Testing Approach:
    - None

#### Staging
- Function:
    - This layer creates the basic building blocks utilized for all downstream data transformations
    - Standardizes and cleans incoming raw data
- Schema: dbt_staging
- Table Names: stg_van__{table}
- Types of Transformations:
    - Clean and format fields such as timezones for dates, common phone or email formats etc.
- Metadata Added:
    - Segment By fields are added to every model
    - Join in table as needed to populate `committeeid`
- Testing Approach:
  - One recency test per vendor
  - Relationship test for segment by values in one table per vendor
  - Primary keys in every table
  - Not null tests for the segment_by in every table
  - Data coverage for key fields as used. Typically written with summary tables
- Exceptions for Activist Pools Project:
    - None

#### Intermediate
- Function:
    - Create tables that are most useful for querying
- Schema: dbt_intermediate
- Table Names:
    - int_van__{table} - tool specific tables
- Types of Transformations:
    - Major joins, transformations, and aggregations
    - Reformat columns and add columns where helpful
- Metadata Added:
    - None
- Testing Approach:
    - Ensure that transformations do not introduce new errors
    - Test transformed fields for accepted values and ranges
    - Test that uniqueness and the number of records is not changed unexpectedly

## Macros

### Source Template
This package leverages a source template to allow for pipeline data to flow from multiple
schemas. Tables are expected to have the same columns, but may have unique prefix or
suffix patterns.