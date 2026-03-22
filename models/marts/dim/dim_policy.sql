{{ config(materialized='table') }}

select
    policy_id as policy_key,
    policy_id,
    policy_number,
    customer_id as customer_key,
    customer_id,
    product_type,
    start_date,
    end_date,
    premium_amount,
    status,
    datediff(day, start_date, coalesce(end_date, current_date())) as policy_duration_days -- coalesce (取第一个非空值)
from {{ ref('stg_policies') }}
