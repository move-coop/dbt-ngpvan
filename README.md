# dbt-ngpvan

An open source repository for applying dbt to NGPVAN pipeline data

***
***

### TABLE OF CONTENTS:

- [**About the package**](#about-the-package)
- [How do I use this package?](#how-do-i-use-this-package)
  - [Step 1: Install the package](#step-1-install-the-package)
  - [Step 2: Define schema variable](#step-2-define-schema-variable)
  - [(Optional) Step 3: Additional configurations](#optional-step-3-additional-configurations)
- [Layers](#layers)
  - [Base](#base)
  - [Staging](#staging)
  - [Intermediate](#intermediate)
- [Macros](#macros)
  - DOCUMENTATION COMING SOON
- [Coming in a future release...](#coming-in-a-future-release)
- [Code of Conduct](#code-of-conduct)

***
***

## About the package

Current version: **v1.1.0**

This package is currently limited to a selection of transactional NGPVAN tables which can contain voterfile data, and several reference/lookup tables used to enhance that data.

Our goal is to add more tables over time and eventually have a complete package covering the 100+ NGPVAN tables provided in their Pipeline sync.

NGPVAN is a complicated system with a lot of variety in functionality and configuration, and every organization uses it differently. We are hoping to develop this package to be extremely flexible and allow for a wide variety of use-cases and levels of complexity.


## How do I use this package?

**NOTE:** The package is currently optimized for BigQuery, but we are working to add Redshift compatability.


### Step 1: Install the package

Include the following dbt-ngpvan package version in your `packages.yml` file:

```
packages:
  - git: "https://github.com/move-coop/dbt-ngpvan.git"
    revision: [">=1.1.0", "<1.2.0"]
```
Run `dbt deps`


### Step 2: Define schema variable

In order to run this package in your dbt project you must first add your source schema to the config settings.

Add the following configuration to your root `dbt_project.yml` file:
```
vars:
  dbt_ngpvan_config:
    schema_list: ['your_schema']
```

If you have raw NGPVAN data in more than one schema, you can list all of them here and the package will union the same raw tables across all schemas. All models include a `source_schema` column so you can differentiate between data coming from different schemas.


### _(Optional)_ Step 3: Additional configurations

There are a number of additional config settings you can use to customize the package to your needs.

Below are the default settings for these configs and more detail on using them.

- **schema_list:** REQUIRED
    - **default:**
    ```
        schema_list: []
    ```

- **vendor_name**
    - **default:**
    ```
        vendor_name: ngpvan
    ```
    - **description:** Many of us use different names to refer to NGPVAN - VAN, SmartVAN, NGP, EveryAction, etc. This setting controls the identifier each model will use in your database.
    - **example:** Changing this setting to 'van' means that running the `base_ngpvan__contactscontacts` model will create a table in your database named `base_van__contactscontacts`

- **source_database**
    - **default:**
    ```
        source_database: target.database
    ```
    - **description:** Most folks won't need to use this setting, only needed if your raw/source data is in a different database than the one set in your `profiles.yml` file.

- **table_logic:**
    - **default:**
    ```
        table_logic: pattern
    ```
    - **description:** By default, each base model in the package looks for any tables in the schema(s) you've listed above that match their table name pattern. This accounts for tables with prefixes (like the `tsm_` used in many SmartVAN tables). **This setting requires that your source tables match the table name patterns typically provided in a VAN Pipeline sync, with no underscores** A table named `tsm_tmc_contactsactivistcodes` will work, but a table named `contacts_activist_codes` will NOT work. If your tables do not match these patterns you'll need to either create views with the correct names, or use the `table_logic: list` setting (still in development).

- **table_exclude_list**
    - **default:**
    ```
        table_exclude_list: []
    ```
    - **description:** List any tables in the source schema(s) which match the table patterns but should NOT be used as sources in the base models.
    - **example:** If you have both mymembers (`_mym`) and voterfile (`_myv` or `_vf`) tables but you don't want both pulled into the base models you can list one set here, e.g. `[contactsactivistcodes_mym]`

- **lookup_tables**:
    - **default:**
    ```
        lookup_tables: false
    ```
    - **description:** Enables/disables staging models for lookup tables. Values from these tables are already being joined into the appropriate staging models, so building stg models for these is typically unnecessary. Includes these tables:
        - `codetypes`
        - `contacttypes`
        - `results`

- **packages**
    - **default:**
    ```
    packages:
      - core:
          enabled: true
      - myvoters:
          enabled: true
    ```
    - **description:** Enables/disables models and certain functionality for different NGPVAN packages, currently only the core and voterfile packages (additional packages are in development). Set `myvoters: enabled: false` if you don't have `_myv` or `_vf` tables.

- **table_list** IN DEVELOPMENT
- **add_ons** IN DEVELOPMENT
- **segmentation** IN DEVELOPMENT



## Layers

### Base

- Function:
    - Prep layer for staging: unions data across schemas into a common table and adds metadata fields
- Default schema: `dbt_base`
- Default table names: `base_{vendor_name | ngpvan}__{tablename}`
- Default materialization: view
- Metadata columns added:
    - `_dbt_source_relation`
    - `source_schema`
    - `source_table`
    - `database_mode` (if myvoters is enabled)
    - `is_myvoters` (if myvoters is enabled)
    - `segment_by` (set to committeeid)
- Additional notes:


### Staging

- Function:
    - This layer creates the basic building blocks utilized for all downstream data transformations
    - Standardizes and cleans incoming raw data
    - Renames columns
- Default schema: `dbt_staging`
- Default table names: `stg_ngpvan__{table_name}`
- Transformations:
    - Clean and format fields such as timestamps, phone numbers, email addresses, etc
- Metadata columns added:
    - All metadata columns created in `base` layer
    -  `vendor` column
- Additional notes:
    - Users may add their own columns by customizing the `ngpvan__stg__additional_fields` macro


### Intermediate

- Function:
    - Create denormalized tables for downstream querying/dashboard/reporting use, and for eventual joins/unions with data from other vendors/platforms.
- Default schema: `dbt_intermediate`
- Default table names: `int_ngpvan__{table_name}`
- Tables included:
    - `int_ngpvan__01__activist_codes`
    - `int_ngpvan__01__admins`
    - `int_ngpvan__01__contacts_attempts`
    - `int_ngpvan__01__survey_responses`
- Transformations:
    - Major joins, transformations, and aggregations
    - Reformat columns and add columns where helpful
- Metadata added:
    - All metadata columns created in `base` and `staging` layers
- Additional notes:
    - Users may add their own columns by customizing the `ngpvan__int__additional_fields` macro

## Macros

*** **DOCUMENTATION COMING SOON** ***

## Coming in a future release...

- Macro documentation
- Add column lists and descriptions to YAML model files
- Complete set of models for "core" NGPVAN package
- Models for additional NPGVAN packages (digital, ngp, development, etc)
- Individual model versioning
- Changelog
- Improved Redshift compatability
- Additional adapter compatability

## Code of Conduct

Please read the [code of conduct](CODE_OF_CONDUCT.md) before using or contributing to this package!
