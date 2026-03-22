{{ config(materialized='view') }}

with source_data as (

    select * from {{ source('raw', 'policies') }}

),

renamed as (

    select
        POLICY_ID,
        CUSTOMER_ID,
        POLICY_NUMBER,
        PRODUCT_TYPE,
        START_DATE,
        END_DATE,
        PREMIUM_AMOUNT,
        STATUS,

    from source_data

)

select * from renamed
