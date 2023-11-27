--Viewing our dataset
SELECT *
FROM SQLDevotee.dbo.Marketing_Campaign

--Adding new tables
ALTER TABLE Marketing_Campaign
ADD Age_Rank NVARCHAR(255)

UPDATE Marketing_Campaign
SET Age_Rank = CASE 
WHEN Year_Birth <= '1963' THEN 'Elderly'
WHEN Year_Birth > '1963' AND Year_Birth <= '1980' THEN 'Middle Age'
ELSE 'Young'
END


ALTER TABLE SQLDevotee.dbo.Marketing_Campaign
Add Partner NVARCHAR(255)

UPDATE SQLDevotee.dbo.Marketing_Campaign
SET Partner = CASE 
WHEN Marital_Status = 'Married' THEN 'Yes'
WHEN Marital_Status = 'Together' THEN 'Yes'
ELSE 'No'
END


ALTER TABLE Marketing_Campaign
ADD Enrol_Date DATE

UPDATE Marketing_Campaign
SET Enrol_Date = CAST(dt_customer AS DATE)


ALTER TABLE SQLDevotee.dbo.Marketing_Campaign
DROP COLUMN Z_CostContact, Z_Revenue
---------------------------------------------------------------

--Dates of the enrolment of the first customer and last customer
SELECT TOP 1 Enrol_Date
FROM SQLDevotee.dbo.Marketing_Campaign
ORDER BY Enrol_Date DESC 
--The first customer joined on the 30th of July, 2012 while the last customer joined on the 29th of June, 2014.


--To find out the lowest, average and highest income based on education levels
SELECT Education,
MIN(Income) lowest,
AVG(Income)  avg,
MAX(Income) highest
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Education


--Examining the complaints category
SELECT COUNT(Complain) Complaints
FROM Marketing_Campaign
WHERE Complain = '1'


SELECT COUNT(Complain) Complaints, Year_Birth,
CASE 
WHEN Year_Birth <= '1963' THEN 'Elderly'
WHEN Year_Birth > '1963' AND Year_Birth <= '1980' THEN 'Middle Age'
ELSE 'Young'
END Ages
FROM Marketing_Campaign
WHERE Complain = '1'
GROUP BY Year_Birth
ORDER BY COUNT(Complain) DESC


--To find out the age groups with the most complaints
SELECT Age_Rank, COUNT(Complain) Age_Group
FROM Marketing_Campaign
WHERE Complain = '1'
GROUP BY Age_Rank
ORDER BY COUNT(Complain) DESC


--To find out the lowest, average and highest income based on age groups
SELECT Age_Rank,
MIN(Income) lowest,
AVG(Income)  avg,
MAX(Income) highest
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Age_Rank





--To find out the number of customers that accepted the offers in each campaign according to their relationship status
SELECT Partner, COUNT(AcceptedCmp1) as AcceptCmp1
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp1 = '1'
GROUP BY Partner
ORDER BY COUNT(AcceptedCmp1) DESC

SELECT Partner, COUNT(AcceptedCmp2) as AcceptCmp2
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp2 = '1'
GROUP BY Partner
ORDER BY COUNT(AcceptedCmp2) DESC

SELECT Partner, COUNT(AcceptedCmp3) as AcceptCmp3
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp3 = '1'
GROUP BY Partner
ORDER BY COUNT(AcceptedCmp3) DESC

SELECT Partner, COUNT(AcceptedCmp4) as AcceptCmp4
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp4 = '1'
GROUP BY Partner
ORDER BY COUNT(AcceptedCmp4) DESC

SELECT Partner, COUNT(AcceptedCmp5) as AcceptCmp5
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp5 = '1'
GROUP BY Partner
ORDER BY COUNT(AcceptedCmp5) DESC
--Results: Cmp1: Partners - 95, Singles - 49; Cmp2: Partners - 19, Singles - 11; Cmp3: Partners - 100, Singles - 63; Cmp4: Partners - 106, Singles - 61; Cmp5: Partners - 110, Singles - 53
--Now according to this, customers with partners accepted the campaigns more than customers with no partners


SELECT Income, COUNT(AcceptedCmp1) as AcceptCmp1
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp1 = '1'
GROUP BY Income
ORDER BY COUNT(AcceptedCmp1) DESC

SELECT Income, COUNT(AcceptedCmp2) as AcceptCmp2
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp2 = '1'
GROUP BY Income
ORDER BY COUNT(AcceptedCmp2) DESC

SELECT Income, COUNT(AcceptedCmp3) as AcceptCmp3
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp3 = '1'
GROUP BY Income
ORDER BY COUNT(AcceptedCmp3) DESC

SELECT Income, COUNT(AcceptedCmp4) as AcceptCmp4
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp4 = '1'
GROUP BY Income
ORDER BY COUNT(AcceptedCmp4) DESC

SELECT Income, COUNT(AcceptedCmp5) as AcceptCmp5
FROM SQLDevotee.dbo.Marketing_Campaign
WHERE AcceptedCmp5 = '1'
GROUP BY Income
ORDER BY COUNT(AcceptedCmp5) DESC


-- What is the total amount spent on prducts according to customers' relationship statuses?
SELECT Partner, SUM(MntWines) Wines, SUM(MntFruits) Fruits, SUM(MntMeatProducts) Meat, SUM(MntFishProducts) Fish, SUM(MntSweetProducts) Sweet, SUM(MntGoldProds) Gold
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Partner
ORDER BY 2 DESC
--As we can see here, the customers in relationships have the highest purchasing power


--Now let's answer this same question according to age groups
SELECT Age_Rank, SUM(MntWines) Wines, SUM(MntFruits) Fruits, SUM(MntMeatProducts) Meat, SUM(MntFishProducts) Fish, SUM(MntSweetProducts) Sweet, SUM(MntGoldProds) Gold
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Age_Rank
ORDER BY 2 DESC
--For this, we can see that the customers in the middle age category have the highest purchasing power


--Age group with the most discounts
SELECT Age_Rank, SUM(NumDealsPurchases) TotalDiscounts
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Age_Rank
ORDER BY TotalDiscounts DESC
--Again, the middle aged customers have made the most purchases with discounts


--Total amount of purchases based on number of kids
SELECT Partner, Income, SUM(Kidhome) + SUM(Teenhome) Kids, SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Partner, Income
ORDER BY AmtPurchase DESC


--Last days since customers' recent purchases
SELECT ID, Enrol_Date, Recency
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY ID, Enrol_Date, Recency
ORDER BY Recency DESC
--More than 200 customers haven't purchased anything for over 90 days. It could be that these are lapsed/churned customers.
--Though, this should not be ascribed to the early enrolment dates, as the last customer to purchase enrolled in 2012; meanwhile a few of the newly enrolled 2014 cohort customers haven't made any purchase for close to a 100 days. 



--Customers with the highest purchasing amount based on number of kids
SELECT Id,  SUM(Kidhome) + SUM(Teenhome) Kids,
	SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id
ORDER BY AmtPurchase DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY
--The top 15 customers with the highest amounts spent have no kids. Says a lot, doesn't it?


--Customers with the highest purchasing amount based on relationships and income
SELECT Id, Partner, Income,
	SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Partner, Income
ORDER BY AmtPurchase DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY
--Wow! People in relationships spent the highest purchasing amount. Hmmm. 


--Based on age and age groups
SELECT Id, Age_Rank, Year_Birth, Income,
	SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Age_Rank, Year_Birth, Income
ORDER BY AmtPurchase DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY


--Based on purchasing style
SELECT Id, Income, NumWebPurchases, NumStorePurchases, NumCatalogPurchases,
	SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Income, NumCatalogPurchases, NumWebPurchases, NumStorePurchases
ORDER BY AmtPurchase DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY
--The top spenders favour store visits, and web purchases are not so popular among them


--Based on number of purchases made with discounts and number of web visits
SELECT Id, Income, SUM(NumDealsPurchases) Discounts,
	SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase,
	SUM(NumWebVisitsMonth) WebVisits
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Income, NumCatalogPurchases, NumWebPurchases, NumStorePurchases
ORDER BY AmtPurchase DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY


SELECT Id, Income, SUM(AcceptedCmp1) + SUM(AcceptedCmp2) + SUM(AcceptedCmp3) + SUM(AcceptedCmp4) + SUM(AcceptedCmp5) CmpSum,
	SUM(MntWines) + SUM(MntFruits) + SUM(MntMeatProducts) + SUM(MntFishProducts) + SUM(MntSweetProducts) + SUM(MntGoldProds) AmtPurchase
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Income, NumCatalogPurchases, NumWebPurchases, NumStorePurchases
ORDER BY AmtPurchase DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY


SELECT Id, Income, Age_Rank, Partner, Education,
	SUM(Kidhome) + SUM(Teenhome) Kids,
	SUM(AcceptedCmp1) + SUM(AcceptedCmp2) + SUM(AcceptedCmp3) + SUM(AcceptedCmp4) + SUM(AcceptedCmp5) CmpSum,
	SUM(NumWebVisitsMonth) WebVisits,
	NumCatalogPurchases, NumStorePurchases, NumWebPurchases
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Income, NumCatalogPurchases, NumWebPurchases, NumStorePurchases, Age_Rank, Partner, Education
ORDER BY CmpSum DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY


--Customers with the highest number of web visits
SELECT Id, Income, Age_Rank, Partner, Education,
	SUM(Kidhome) + SUM(Teenhome) Kids,
	SUM(AcceptedCmp1) + SUM(AcceptedCmp2) + SUM(AcceptedCmp3) + SUM(AcceptedCmp4) + SUM(AcceptedCmp5) CmpSum,
	SUM(NumWebVisitsMonth) WebVisits,
	SUM(NumDealsPurchases) Discounts,
	NumCatalogPurchases, NumStorePurchases, NumWebPurchases
FROM SQLDevotee.dbo.Marketing_Campaign
GROUP BY Id, Income, NumCatalogPurchases, NumWebPurchases, NumStorePurchases, Age_Rank, Partner, Education
ORDER BY WebVisits DESC
OFFSET 0 ROWS
FETCH NEXT 50 ROWS ONLY
--As we can see, these group of customers are some of the lowest income earners who have significantly low numbers of catalog, store and web purchases and who didn't accept campaigns
