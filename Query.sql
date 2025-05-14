select * from finance_data;


SELECT SUM(Amount) AS Total_Revenue
FROM finance_data
WHERE Category = 'Revenue';


SELECT SUM(Amount) AS Total_Expenses
FROM finance_data
WHERE Category = 'Expense';


SELECT 
    SUM(CASE WHEN Category = 'Revenue' THEN Amount ELSE 0 END) -
    SUM(CASE WHEN Category = 'Expense' THEN Amount ELSE 0 END) AS Net_Profit
FROM finance_data;


SELECT 
    MONTH(Date) AS Month,
    SUM(Amount) AS Monthly_Revenue
FROM finance_data
WHERE Category = 'Revenue'
GROUP BY MONTH(Date);


SELECT DISTINCT Category
FROM finance_data;


SELECT Sub_Category, SUM(Amount) AS Total
FROM finance_data
GROUP BY Sub_Category;


SELECT 
    MONTH(Date) AS Month,
    SUM(CASE WHEN Category = 'Revenue' THEN Amount ELSE 0 END) -
    SUM(CASE WHEN Category = 'Expense' THEN Amount ELSE 0 END) AS Net_Profit
FROM finance_data
GROUP BY MONTH(Date)
ORDER BY Month;


SELECT 
    Sub_Category, 
    SUM(Amount) AS Total_Expense
FROM finance_data
WHERE Category = 'Expense'
GROUP BY Sub_Category
ORDER BY Total_Expense DESC
LIMIT 5;


SELECT 
    AVG(MonthlyRevenue) AS Avg_Monthly_Revenue
FROM (
    SELECT MONTH(Date) AS Month, SUM(Amount) AS MonthlyRevenue
    FROM finance_data
    WHERE Category = 'Revenue'
    GROUP BY MONTH(Date)
) AS MonthlyData;


SELECT 
    MONTH(Date) AS Month,
    ROUND(
        (SUM(CASE WHEN Category = 'Revenue' THEN Amount ELSE 0 END) -
         SUM(CASE WHEN Category = 'Expense' THEN Amount ELSE 0 END)) /
         SUM(CASE WHEN Category = 'Revenue' THEN Amount ELSE 0 END) * 100, 2
    ) AS Profit_Margin_Percent
FROM finance_data
GROUP BY MONTH(Date);


SELECT 
    Category,
    Sub_Category,
    SUM(Amount) AS Total_Amount
FROM finance_data
GROUP BY Category, Sub_Category
ORDER BY Total_Amount DESC;

