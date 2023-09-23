-- To connect to the international_debt database 
%%sql
postgresql:///international_debt
  
-- SELECT all of the columns from the international_debt table
Select * from international_debt
LIMIT 10;

--Totaling the amount of debt owed by the countries
SELECT ROUND(SUM(debt)/1000000,2) as total_debt
FROM international_debt;
-- total debt 3079734.49

-- number of distinct countries taking debt
SELECT COUNT(Distinct country_name) AS num_of_countries
FROM international_debt;
-- Ans: 124

-- Finding out the distinct debt indicators
Select distinct indicator_code as distinct_debt_indicators
From international_debt
order by distinct_debt_indicators;

-- Ans: There are 25 distinct indicators in the list.

-- The total amount of debt (in USD) that is owed by the different countries. This will give us a sense of how the overall economy of the entire world is holding up.
SELECT country_name, ROUND(SUM(debt),2) as total_debt
FROM international_debt
group by country_name;

-- Country with the highest debt
SELECT 
    country_name, ROUND(SUM(debt),2) as total_debt
FROM international_debt
group by country_name
order by ROUND(SUM(debt),2) desc
LIMIT 1;
-- Ans: CHINA with total_debt: 285793494734.20

-- Average amount of debt across different indicators
SELECT 
    ROUND(AVG(debt),2) AS average_debt,
    indicator_name, indicator_code
FROM international_debt
GROUP BY indicator_name, indicator_code
ORDER BY average_debt desc
LIMIT 10;

-- Ans: Highest avg_debt indicator- Principal repayments on external debt, long-term (AMT, current US$)
-- High avg_debt indicator_code: DT.AMT.DLXF.CD  corresponds to the indicator_name above.
-- It's avg_debt: 5904868401.50
-- Second Row: 5161194333.81	  Principal repayments on external debt, private nonguaranteed (PNG) (AMT, current US$)	  DT.AMT.DPNG.CD
-- Third Row:   2152041216.89	  Disbursements on external debt, long-term (DIS, current US$)	                          DT.DIS.DLXF.CD
-- An interesting observation in the above finding is that there is a huge difference in the amounts of the indicators after the second one. This indicates that the first two indicators might be the most severe categories in which the countries owe their debts.

-- to find out which country owes the highest amount of debt in the category of long term debts 
SELECT 
    country_name, 
    debt
FROM international_debt
WHERE indicator_code = 
  (SELECT indicator_code
  FROM international_debt
  group by indicator_code
  order by avg(debt) desc
  LIMIT 1)
Order by debt desc;

--Ans: 124 countries have taken debt in the long-term debt category; China has the highest debt among these.

-- We saw that long-term debt is the topmost category when it comes to the average amount of debt. But is it the most common indicator in which the countries owe their debt?
Select indicator_code, count(indicator_code) as indicator_count
from international_debt
group by indicator_code
order by indicator_count desc, indicator_code desc
LIMIT 20;

-- There are six indicator codes with 124 indicator_count, and yes, the long-term debt indicator is in it. Hence, it is one of the most common indicators.

--There are a total of six debt indicators in which all the countries listed in our dataset have taken debt. The indicator DT.AMT.DLXF.CD is also there in the list. So, this gives us a clue that all these countries are suffering from a common economic issue. 

-- Let's find out the maximum amount of debt that each country has.
Select country_name, MAX(debt) as maximum_debt
from international_debt
group by country_name
order by maximum_debt desc
LIMIT 10;
-- China has the highest maximum_debt followed by Brazil.

