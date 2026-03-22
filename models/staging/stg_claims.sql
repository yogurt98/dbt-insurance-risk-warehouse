{{ config(materialized='view') }}

with source_data as (

    select * from {{ source('raw', 'claims') }}

),

renamed as (

    select
        CLAIM_ID,
        POLICY_ID,
        CLAIM_DATE,
        CLAIM_AMOUNT,
        CLAIM_STATUS,
        CLAIM_TYPE,

    from source_data

)

select * from renamed
