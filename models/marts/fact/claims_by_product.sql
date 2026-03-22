{{ 
    config(
        materialized='table',
        description='按产品类型汇总理赔情况：数量、金额、比率等'
        
        ) }}

select
    p.product_type,
    count(f.claim_key) as total_claims,
    count(distinct f.policy_key) as unique_policies_with_claims,
    round(avg(f.claim_amount), 2) as avg_claim_amount,
    round(sum(f.claim_amount), 0) as total_claim_amount,
    round(sum(case when f.claim_status = 'Approved' then f.claim_amount else 0 end), 0) as approved_claim_amount,
    round(count(f.claim_key) * 100.0 / nullif(count(distinct p.policy_key), 0), 2) as claim_frequency_pct,
    round(sum(f.claim_amount) * 100.0 / nullif(sum(p.premium_amount), 0), 2) as loss_ratio_pct_approx
from {{ ref('fact_claims') }} f
left join {{ ref('dim_policy') }} p on f.policy_key = p.policy_key
group by p.product_type
order by total_claim_amount desc
