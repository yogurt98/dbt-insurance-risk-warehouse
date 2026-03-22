{{ config(
        materialized='table',
        description='按月、产品类型汇总的平均风险分数，用于风险趋势监控和产品定价参考。'


) }}

with monthly_risk as (
    select
        d.year,
        d.month,
        d.month_name,
        d.date_key,
        p.product_type,
        avg(r.risk_score) as avg_risk_score,
        count(distinct c.customer_key) as unique_customers,
        count(distinct p.policy_key) as active_policies_approx
    from {{ ref('fact_claims') }} f
    left join {{ ref('dim_date') }} d 
        on f.claim_date_key = d.date_key
    left join {{ ref('dim_policy') }} p 
        on f.policy_key = p.policy_key
    left join {{ ref('dim_risk_factor') }} r 
        on f.risk_factor_key = r.risk_factor_key
    left join {{ ref('dim_customer') }} c 
        on f.customer_key = c.customer_key
    where f.claim_status = 'Approved'  -- 只看已批准理赔的风险
      and r.risk_score is not null
    group by 
        d.year, d.month, d.month_name, d.date_key, p.product_type
)

select * from monthly_risk
order by year desc, month desc, product_type
