# 🏛️ Insurance Risk Data Warehouse (dbt + Snowflake)

![dbt](https://img.shields.io/badge/dbt-1.8+-FF694B)
![Snowflake](https://img.shields.io/badge/Snowflake-Enterprise-29B6F6)
![License](https://img.shields.io/badge/License-MIT-green)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB)


**End-to-end Insurance Risk Data Warehouse** built with **dbt + Snowflake**, featuring **Kimball dimensional modeling** (Star + Snowflake schema).

Processes **100,000+** synthetic actuarial records and delivers actionable analytics for risk management, pricing, and customer profitability.

---

## 📌 Project Overview

This project demonstrates a complete modern ELT pipeline in the **insurance domain**:

- Raw synthetic data → Staging → Dimensional Marts → Business Analytics
- Central fact table: `fact_claims`
- Snowflake schema on `dim_risk_factor`
- 3 production-ready analytics marts for actuarial use cases

### 🏗️ Data Architecture
- **Fact Table:** `fact_claims` (Core transactional data)
- **Dimension Tables:** `dim_customer`, `dim_policy`, `dim_date`, `dim_risk_factor` (Snowflake schema integration)
- **Analytics Layer:** Pre-aggregated views tailored for actuarial and business reporting.

## 🛠️ Tech Stack
- **Data Warehouse:** Snowflake (Enterprise Trial via Partner Connect)
- **Transformation & Modeling:** dbt Core & dbt Cloud (Developer Free Plan)
- **Data Modeling:** Kimball Methodology
- **Data Quality & Testing:** dbt native tests (`not_null`, `unique`, `relationships`, `accepted_values`)
- **Documentation:** dbt docs + auto-generated lineage graphs

## 📂 Project Structure
```text
models/
├── sources.yml           # Source definitions and freshness rules
├── staging/              # Lightweight cleansing and standardization views
├── marts/
│   ├── dim/              # Dimension tables
│   ├── fact/             # Fact tables
│   └── analytics/        # Business-facing analytical models
└── sources.yml            # Model definitions 
```

## 💡 Business Value & Analytics
The `analytics` layer provides immediate value for risk assessment and product performance evaluation:

- **Monthly Risk Score**: Tracks average risk trends by product and month — supports dynamic pricing and underwriting decisions.


- **Claims by Product**: Calculates **Loss Ratio**, claim frequency, and severity by product line (Auto / Home / Life / Health).


- **Customer LTV**: Estimates net customer contribution and lifetime profitability, enabling better customer segmentation and retention strategies.

## 📊 Data Lineage & Snowflake Implementation

<image-card alt="Lineage - Fact Claims" src="screenshots/img.png" ></image-card>
<image-card alt="Lineage - Monthly Risk Score" src="screenshots/img_1.png" ></image-card>

<image-card alt="Mart Schema Overview" src="screenshots/img_2.png" ></image-card>
<image-card alt="Stage Schema Overview" src="screenshots/img_3.png" ></image-card>
<image-card alt="Snowflake dim_policy" src="screenshots/img_4.png" ></image-card>

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
### 4. Build & Test
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



## 📬 Contact
Jingxu Lan | Waterloo, ON | Data Engineer Candidate
