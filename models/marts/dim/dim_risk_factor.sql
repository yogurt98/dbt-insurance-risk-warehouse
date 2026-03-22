{{ config(
    materialized='table',
) }}

with risk_data as (
    select * from {{ ref('stg_risk_factors') }}
),
customer_dim as (
    select * from {{ ref('dim_customer') }}
)

select
    r.risk_factor_id as risk_factor_key,
    r.risk_factor_id,
    r.customer_id,
    c.customer_key,
    r.risk_score,
    r.smoking_status,
    r.bmi,
    r.driving_record_points,
    r.last_assessment_date,
    datediff(day, r.last_assessment_date, current_date()) as days_since_assessment
from risk_data r
left join customer_dim c 
    on r.customer_id = c.customer_id
