import pandas as pd
from faker import Faker
import random
from datetime import date, timedelta

fake = Faker('en_CA')
random.seed(42)
Faker.seed(42)

NUM_CUSTOMERS = 10000
NUM_POLICIES = 40000
NUM_CLAIMS = 40000
NUM_RISK = 10000

# 1. Customers
customers = []
for i in range(1, NUM_CUSTOMERS + 1):
    customers.append({
        'customer_id': i,
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'date_of_birth': fake.date_of_birth(minimum_age=18, maximum_age=80).isoformat(),
        'address': fake.street_address(),
        'city': fake.city(),
        'province': 'ON',
        'postal_code': fake.postalcode(),
        'email': fake.email(),
        'phone': fake.phone_number(),
        'join_date': fake.date_between(start_date='-5y', end_date=date.today()).isoformat()
    })
pd.DataFrame(customers).to_csv('customers.csv', index=False)

# 2. Policies
policies = []
product_types = ['Auto', 'Home', 'Life', 'Health']
for i in range(1, NUM_POLICIES + 1):
    start_date = fake.date_between(start_date='-3y', end_date=date.today())
    policies.append({
        'policy_id': i,
        'customer_id': random.randint(1, NUM_CUSTOMERS),
        'policy_number': f'POL-{i:08d}',
        'product_type': random.choice(product_types),
        'start_date': start_date.isoformat(),
        'end_date': (start_date + timedelta(days=random.randint(365, 1825))).isoformat() if random.random() > 0.2 else None,
        'premium_amount': round(random.uniform(50, 500), 2),
        'status': random.choice(['Active', 'Lapsed', 'Cancelled'])
    })
pd.DataFrame(policies).to_csv('policies.csv', index=False)

# 3. Claims
claims = []
claim_types = ['Accident', 'Theft', 'Medical', 'Death']
for i in range(1, NUM_CLAIMS + 1):
    claims.append({
        'claim_id': i,
        'policy_id': random.randint(1, NUM_POLICIES),
        'claim_date': fake.date_between(start_date='-2y', end_date=date.today()).isoformat(),
        'claim_amount': round(random.uniform(100, 50000), 2),
        'claim_status': random.choice(['Approved', 'Denied', 'Pending']),
        'claim_type': random.choice(claim_types)
    })
pd.DataFrame(claims).to_csv('claims.csv', index=False)

# 4. Risk Factors（雪花型关联 customer）
risk_factors = []
for i in range(1, NUM_RISK + 1):
    risk_factors.append({
        'risk_factor_id': i,
        'customer_id': random.randint(1, NUM_CUSTOMERS),
        'risk_score': random.randint(0, 100),
        'smoking_status': random.choice(['Y', 'N']),
        'bmi': round(random.uniform(18.5, 40.0), 1),
        'driving_record_points': random.randint(0, 10),
        'last_assessment_date': fake.date_between(start_date='-1y', end_date=date.today()).isoformat()
    })
pd.DataFrame(risk_factors).to_csv('risk_factors.csv', index=False)

print("✅ 生成成功！4 个 CSV 文件（customers.csv, policies.csv, claims.csv, risk_factors.csv）总计 ~10 万条合成精算数据。")