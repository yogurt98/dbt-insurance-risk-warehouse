{{ 
    config(
        materialized='table',
        description='客户终身价值估算：累计保费 - 累计理赔 + 一些简单因子'

) }}

with customer_metrics as (
    select
        c.customer_key,
        c.full_name,
        c.age,
        c.province,
        c.join_year,
        count(distinct p.policy_key) as policy_count,
        round(sum(p.premium_amount), 2) as total_premium_paid,
        round(sum(f.approved_claim_amount), 2) as total_claims_paid_out,
        round(sum(p.premium_amount) - sum(coalesce(f.approved_claim_amount, 0)), 2) as net_contribution,
        round(avg(r.risk_score), 1) as avg_risk_score,
        max(r.days_since_assessment) as days_since_last_assessment
    from {{ ref('dim_customer') }} c
    left join {{ ref('dim_policy') }} p 
        on c.customer_key = p.customer_key
    left join {{ ref('fact_claims') }} f 
        on p.policy_key = f.policy_key
    left join {{ ref('dim_risk_factor') }} r 
        on c.customer_key = r.customer_key
    group by 
        c.customer_key, c.full_name, c.age, c.province, c.join_year
)

select
    *,
    case 
        when total_premium_paid > 0 
        then round(net_contribution * 1.0 / total_premium_paid, 4) 
        else 0 
    end as profitability_ratio,
    -- 简单 LTV 估算：净贡献 × 预期剩余年限（粗估）
    round(net_contribution * greatest( (80 - age) / 5.0, 1), 0) as estimated_ltv
from customer_metrics
order by estimated_ltv desc
limit 10000  -- 避免太大，实际可去掉

