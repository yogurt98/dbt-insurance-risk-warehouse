# Insurance Risk Data Warehouse (dbt + Snowflake)

## 项目概述
使用 dbt + Snowflake 构建的保险风险数据仓库，采用 Kimball 维度建模（星型 + 雪花型），包含：
- 合成精算数据（10万条）：客户、保单、理赔、风险因子
- 层次：raw → staging → marts (dim + fact + analytics)
- 核心事实表：fact_claims
- 维度：dim_customer, dim_policy, dim_date, dim_risk_factor (雪花型)
- 分析层：Monthly Risk Score, Claims by Product, Customer LTV

## 技术栈
- Snowflake (Enterprise Trial via Partner Connect)
- dbt Cloud (Developer 免费计划)
- 维度建模：Kimball 方法
- 测试：not_null, unique, relationships, accepted_values
- 文档：dbt docs + lineage 图

## 项目结构
models/

├── sources.yml 

├── staging/          # 轻量清洗视图

├── marts/

│   ├── dim/          # 维度表

│   ├── fact/         # 事实表

│   └── analytics/    # 业务分析层

└── schema.yml        # 测试定义

## 🚀 How to Run This Project Locally

### Prerequisites
- Python 3.10+
- Snowflake account (with a database `INSURANCE_DB`)
- dbt Core installed (`pip install dbt-snowflake`)

### 1. Clone the repository
```bash
git clone https://github.com/yogurt98/dbt-insurance-risk-warehouse.git
cd dbt-insurance-risk-warehouse
```
### 2. Install dependencies
```bash
pip install dbt-snowflake
dbt deps
```
### 3. Configure connection
Create a profiles.yml file in the project root (or in ~/.dbt/profiles.yml):
```bash
insurance_risk_dwh:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account_name   # e.g. xy12345.ca-central-1.aws
      user: your_username
      password: your_password      # or use key-pair auth (recommended)
      role: ACCOUNTADMIN
      database: INSURANCE_DB
      warehouse: DBT_WH
      schema: MARTS
      threads: 4
```
### 4. Run the project
```bash
# Run all models
dbt run

# Run tests
dbt test

# Generate documentation (with lineage)
dbt docs generate
dbt docs serve
```
## Alternative: Run in dbt Cloud

1. Create a new project in dbt Cloud
2. Connect this GitHub repository
3. Set up the Snowflake connection
4. Run `dbt run` / `dbt build` in the IDE

**Note**: This project uses synthetic insurance data (policies, claims, risk factors). All models are built with Kimball dimensional modeling (star + snowflake schema).

## 业务价值
- Monthly_Risk_Score：监控产品风险趋势
- Claims_By_Product：计算损失率、理赔频率
- Customer_LTV：粗估客户净贡献与终身价值

## Lineage 示例
![img.png](screenshots/img.png)

![img_1.png](screenshots/img_1.png)

## 联系
Jingxu Lan | Waterloo, ON | Data Engineer Candidate
