{{ config(materialized='view') }}

with source_data as (

    select * from {{ source('raw', 'customers') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        date_of_birth,
        address,
        city,
        province,
        postal_code,
        email,
        phone,
        join_date

    from source_data

)

select * from renamed
