{{ config(materialized='table') }}

with dates as (
    select 
        dateadd(day, '-' || seq4(), current_date()) as date  -- '||' 拼接法在某些旧式 SQL 习惯中非常流行，直观地表达了“我要往回减”的意思
    from table(generator(rowcount => 365 * 20))  -- 过去20年 + 未来少量
    union all
    select dateadd(day, seq4(), current_date() + 1)  -- 未来1年
    from table(generator(rowcount => 365))
)

select
    to_number(to_char(date, 'YYYYMMDD')) as date_key,
    date,
    year(date) as year,
    quarter(date) as quarter,
    month(date) as month,
    monthname(date) as month_name,
    dayofmonth(date) as day,
    dayofweek(date) as day_of_week,
    dayname(date) as day_name,
    weekofyear(date) as week_of_year,
    case 
        when month(date) in (1,2,3) then 'Q1'
        when month(date) in (4,5,6) then 'Q2'
        when month(date) in (7,8,9) then 'Q3'
        else 'Q4'
    end as fiscal_quarter,
    year(date) || '-Q' || quarter(date) as fiscal_year_quarter,
    true as is_weekend  -- 可以后续完善假期逻辑
from dates
order by date 
