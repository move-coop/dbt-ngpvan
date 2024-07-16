
{{
    config(
        alias='base_' ~ var("dbt_ngpvan_config")["vendor_name"] ~ '__surveyquestions'
    )
}}

WITH
    base AS (

        {{
            ngpvan__union_source_tables(
                table_pattern='surveyquestions'
            )
        }}

    ),

    committee_mapping AS (
        SELECT DISTINCT

            CommitteeID,
            SurveyQuestionID

        FROM {{ ref("base_ngpvan__contactssurveyresponses") }}
        UNION DISTINCT
        SELECT DISTINCT

            CommitteeID,
            SurveyQuestionID

        FROM {{ ref("base_ngpvan__surveyresponses")}}
    ),

    segment_by AS (

        SELECT
            
            base.*,
            committee_mapping.CommitteeID AS committeeid

        FROM base
        LEFT JOIN committee_mapping
            USING(SurveyQuestionID)
       
    )


SELECT DISTINCT
    *,
    {{
    ngpvan__metadata__generate_fields(
        segment_by_column='committeeid'
    )
    }}
FROM segment_by
