{{ 
    config(
        materialized='table',
        description='核心理赔事实表，整合保单、客户、日期、风险因子维度。支持理赔金额、状态、发生时机分析。'
) }}

select
    -- 代理键（可选，后续可加 dbt-surrogate-key 宏）
    cl.claim_id as claim_key,
    
    -- 维度外键
    cl.claim_id,
    cl.policy_id,
    p.policy_key,
    p.customer_id,
    c.customer_key,
    to_number(to_char(cl.claim_date, 'YYYYMMDD')) as claim_date_key,
    r.risk_factor_key,  -- 雪花型关联
    
    -- 度量
    cl.claim_amount,
    cl.claim_date,
    cl.claim_status,
    cl.claim_type,
    
    -- 一些派生指标
    case when cl.claim_status = 'Approved' then cl.claim_amount else 0 end as approved_claim_amount,
    datediff(day, p.start_date, cl.claim_date) as days_from_policy_start_to_claim

from {{ ref('stg_claims') }} cl
left join {{ ref('dim_policy') }} p 
    on cl.policy_id = p.policy_id
left join {{ ref('dim_customer') }} c 
    on p.customer_id = c.customer_id
left join {{ ref('dim_risk_factor') }} r 
    on c.customer_key = r.customer_key 
    and datediff(day, r.last_assessment_date, cl.claim_date) between 0 and 365  -- 最近一年有效的风险因子
left join {{ ref('dim_date') }} d 
    on to_number(to_char(cl.claim_date, 'YYYYMMDD')) = d.date_key
