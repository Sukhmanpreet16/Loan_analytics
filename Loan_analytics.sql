-- Portfolio exposure and risk summary
SELECT 
    SUM(funded_amnt) AS total_exposure,
    
    SUM(funded_amnt * int_rate) / SUM(funded_amnt) 
        AS weighted_avg_interest_rate,
        
    AVG(default_flag::float) 
        AS portfolio_default_rate

from loan_analytics;

-- Risk-Adjusted Yield by Grade
SELECT 
    grade,
    
    AVG(int_rate) AS avg_interest_rate,
    
    AVG(default_flag::float) AS default_rate,
    
    AVG(default_flag::float) * 
        AVG(loan_amnt - total_rec_prncp - recoveries) 
        AS approx_loss_rate,
        
    AVG(int_rate) - 
        (AVG(default_flag::float) * 
        AVG(loan_amnt - total_rec_prncp - recoveries)) 
        AS net_yield_proxy

FROM loan_analytics
GROUP BY grade
ORDER BY net_yield_proxy DESC;

-- Term Risk Comparison (36 vs 60)
SELECT 
    term,
    
    COUNT(*) AS total_loans,
    
    AVG(default_flag::float) AS default_rate,
    
    AVG(int_rate) AS avg_interest_rate,
    
    AVG(int_rate) - 
        (AVG(default_flag::float) * 
        AVG(loan_amnt - total_rec_prncp - recoveries)) 
        AS net_yield_proxy

FROM loan_analytics
GROUP BY term
ORDER BY term;

-- Vintage Analysis (Cohort Default Rate)
SELECT 
    issue_d AS issue_date,
    
    COUNT(*) AS loans_issued,
    
    SUM(funded_amnt) AS exposure,
    
    AVG(default_flag::float) AS default_rate

FROM loan_analytics
GROUP BY issue_date
ORDER BY issue_date;

-- DTI Band Segmentation
SELECT 
    CASE 
        WHEN dti < 10 THEN '0-10'
        WHEN dti < 20 THEN '10-20'
        WHEN dti < 30 THEN '20-30'
        ELSE '30+'
    END AS dti_band,
    
    COUNT(*) AS loans,
    AVG(default_flag::float) AS default_rate

FROM loan_analytics
GROUP BY dti_band
ORDER BY dti_band;

--Income Based Risk Analysis
SELECT 
    CASE 
        WHEN annual_inc < 40000 THEN '<40K'
        WHEN annual_inc < 80000 THEN '40K-80K'
        WHEN annual_inc < 120000 THEN '80K-120K'
        ELSE '120K+'
    END AS income_band,
    
    COUNT(*) AS loans,
    SUM(funded_amnt) AS exposure,
    AVG(default_flag::float) AS default_rate

FROM loan_analytics
GROUP BY income_band
ORDER BY income_band;

-- Loan amount vs Default Behaviour
SELECT 
    CASE 
        WHEN loan_amnt < 5000 THEN '<5K'
        WHEN loan_amnt < 15000 THEN '5K-15K'
        WHEN loan_amnt < 30000 THEN '15K-30K'
        ELSE '30K+'
    END AS loan_band,
    
    COUNT(*) AS loans,
    AVG(default_flag::float) AS default_rate,
    AVG(dti) AS avg_dti

FROM loan_analytics
GROUP BY loan_band
ORDER BY loan_band;

-- Purpose Based Risk and Profitability
SELECT 
    purpose,
    
    COUNT(*) AS loans,
    
    AVG(int_rate) AS avg_interest_rate,
    
    AVG(default_flag::float) AS default_rate,
    
    AVG(int_rate) - 
        (AVG(default_flag::float) * 
        AVG(loan_amnt - total_rec_prncp - recoveries)) 
        AS net_yield_proxy

FROM loan_analytics
GROUP BY purpose
ORDER BY net_yield_proxy DESC;

-- Early Default Risk Signal
SELECT 
    CASE 
        WHEN delinq_2yrs = 0 THEN '0'
        WHEN delinq_2yrs BETWEEN 1 AND 2 THEN '1-2'
        ELSE '3+'
    END AS delinquency_segment,
    
    COUNT(*) AS loans,
    AVG(default_flag::float) AS default_rate

FROM loan_analytics
GROUP BY delinquency_segment
ORDER BY delinquency_segment;

-- Concentration Risk
SELECT 
    grade,
    
    SUM(funded_amnt) AS exposure,
    
    SUM(funded_amnt) * 100.0 / 
        SUM(SUM(funded_amnt)) OVER () 
        AS exposure_pct,
        
    SUM(default_flag) AS total_defaults

FROM loan_analytics
GROUP BY grade
ORDER BY exposure_pct DESC;

-- Loss Estimation And Expected Loss
WITH loss_calc AS (
    SELECT 
        default_flag,
        (loan_amnt - total_rec_prncp - recoveries) AS loss_amount
    FROM loan_analytics
)

SELECT 
    AVG(loss_amount) AS avg_loss_severity,
    
    AVG(default_flag::float) AS default_rate,
    
    AVG(default_flag::float) * 
        AVG(loss_amount) AS expected_loss_proxy

FROM loss_calc;

-- Approval Strategy Simulation(A-C)
SELECT 
    COUNT(*) AS approved_loans,
    
    SUM(funded_amnt) AS approved_exposure,
    
    AVG(default_flag::float) AS new_default_rate,
    
    AVG(int_rate) -
        (AVG(default_flag::float) * 
        AVG(loan_amnt - total_rec_prncp - recoveries)) 
        AS new_net_yield_proxy

FROM loan_analytics
WHERE grade IN ('A','B','C');

