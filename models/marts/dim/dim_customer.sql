{{ config(materialized='table') }}

select
    customer_id as customer_key,  -- 代理键，建议用 surrogate key，但这里先用业务键
    customer_id,
    first_name || ' ' || last_name as full_name,
    date_of_birth,
    datediff(year, date_of_birth, current_date()) as age,
    province,
    city,
    postal_code,
    join_date,
    year(join_date) as join_year
from {{ ref('stg_customers') }}

