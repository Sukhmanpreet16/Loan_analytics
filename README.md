# Loan Portfolio Risk & Profitability Analytics  
PostgreSQL + Python Credit Risk Analysis Project

---

## Business Problem

A ₹416M consumer lending portfolio required evaluation to determine whether interest income sufficiently compensates for credit risk and to identify segments driving default concentration and profitability erosion.

---

## Project Objective

To analyze portfolio exposure, credit segmentation, risk-adjusted yield, concentration risk, and simulate credit policy optimization using structured SQL analytics.

---

## Dataset Overview

The dataset contains consumer loan-level information including:

- Loan amount and funded amount  
- Interest rate and term  
- Credit grade and sub-grade  
- Annual income and DTI  
- Delinquency and inquiry history  
- Loan purpose and state  
- Issue date  
- Repayment performance (Fully Paid vs Charged Off)  

A binary `default_flag` was engineered for risk modeling:
- 0 = Fully Paid  
- 1 = Charged Off  

---

## Data Preparation (Python)

- Cleaned raw lending data and filtered terminal loan statuses to avoid performance bias.
- Engineered `default_flag` and standardized numeric fields for financial precision.
- Handled missing bureau count variables (delinquencies, bankruptcies, inquiries).
- Ensured correct data types before bulk loading into PostgreSQL.
- Exported clean dataset and loaded via optimized COPY method.

---

## SQL Analysis Modules (PostgreSQL)

Twelve structured portfolio analytics modules were developed:

### 1. Portfolio Exposure & Risk Summary
- Total funded exposure
- Weighted average interest rate
- Portfolio default rate

### 2. Risk-Adjusted Yield by Grade
- Average interest rate by grade
- Default rate by grade
- Net yield proxy after accounting for losses

### 3. Term Risk Comparison
- Default comparison between 36 and 60 month loans
- Yield vs risk trade-off evaluation

### 4. Vintage (Cohort) Analysis
- Default rate by issue month/year
- Exposure growth vs credit performance trend

### 5. DTI Risk Segmentation
- Default rate by borrower leverage bands

### 6. Income Risk Segmentation
- Default rate and exposure across income buckets

### 7. Loan Amount Risk Analysis
- Default behavior across loan size bands
- DTI interaction analysis

### 8. Purpose-Based Risk Evaluation
- Risk and profitability by loan purpose
- Identification of high-risk product segments

### 9. Early Risk Signal Analysis
- Impact of prior delinquencies on default rate

### 10. Concentration Risk Assessment
- Exposure percentage by credit grade
- Contribution to total defaults

### 11. Expected Loss Estimation
- Average loss severity
- Portfolio-level expected loss proxy

### 12. Credit Policy Simulation
- Approval restriction to Grades A–C
- Comparison of exposure and default rate before and after policy tightening

---

## Key Findings

- Portfolio default rate (14.6%) materially offsets weighted average yield (12.7%).
- Lower credit grades (D–G) significantly deteriorate risk-adjusted returns.
- 60-month loans default at more than double the rate of 36-month loans.
- Larger loan amounts (>30K) show materially higher default rates.
- Lower income and higher DTI borrowers exhibit strong risk correlation.
- Small business loans demonstrate highest default rates (~27%).
- Grade B represents the largest exposure concentration (~30%).
- Restricting approvals to Grades A–C reduces default rate from 14.6% to 11.4%, improving portfolio stability.

---

## Business Impact

The analysis demonstrates how structured portfolio segmentation and credit policy simulation can:

- Reduce concentration risk
- Improve risk-adjusted yield
- Identify high-risk product segments
- Optimize approval strategy
- Support data-driven lending decisions

---

## Tech Stack

- Python (Pandas, NumPy)
- PostgreSQL
- psycopg2
- Advanced SQL (aggregations, CASE segmentation, cohort grouping)

---

## Conclusion

This project replicates real-world credit portfolio analytics workflows, combining data cleaning, financial metric design, risk segmentation, expected loss estimation, and approval strategy simulation to evaluate and optimize lending performance.

