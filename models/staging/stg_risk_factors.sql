{{ config(materialized='view') }}

with source_data as (

    select * from {{ source('raw', 'risk_factors') }}

),

renamed as (

    select
        RISK_FACTOR_ID,
        CUSTOMER_ID,
        RISK_SCORE,
        SMOKING_STATUS,
        BMI,
        DRIVING_RECORD_POINTS,
        LAST_ASSESSMENT_DATE,

    from source_data

)

select * from renamed
