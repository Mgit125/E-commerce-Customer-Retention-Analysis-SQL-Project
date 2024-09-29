
CREATE TABLE E_commerce_retail_data
(
	Csat_score INT,
	Response_time FLOAT,
	Daily_User_Logins INT,
	Average_Session_Duration FLOAT,
	Survey_Response_Rate FLOAT,
	Transaction_Amount FLOAT,
	Product_Rating INT,
	Preferred_Communication_Channel VARCHAR(50),
	Membership_Status VARCHAR(20),
	Product_Category_Preference VARCHAR(20),
	High_Value_Purchase_Count FLOAT,
	Customer_Support_Calls INT,
	Website_Click_Through_Rate INT,
	Newsletter_Open_Rate FLOAT,
	Social_Media_Engagement_Score FLOAT,
	Referral_Count INT,
	Account_Age_days INT,
	Feedback_Score INT,
	Product_Return_Rate VARCHAR(10),
	Marketing_Email_Click_Rate FLOAT,
	Subscription_Status INT,
	Product_Upsell_Success INT,
	Customer_Segment_Group VARCHAR(10),
	Interest_in_New_Product VARCHAR(10),
	Income_Level VARCHAR(15)
);


SELECT * FROM E_commerce_retail_data;
------------------------------------------------Error occcured due to INT instead of Float at 'Customer_Support_Calls INT'

DROP TABLE E_commerce_retail_data;




CREATE TABLE E_commerce_retail_data
(
	Csat_score INT,
	Response_time FLOAT,
	Daily_User_Logins INT,
	Average_Session_Duration FLOAT,
	Survey_Response_Rate FLOAT,
	Transaction_Amount FLOAT,
	Product_Rating INT,
	Preferred_Communication_Channel VARCHAR(50),
	Membership_Status VARCHAR(20),
	Product_Category_Preference VARCHAR(20),
	High_Value_Purchase_Count FLOAT,
	Customer_Support_Calls INT,
	Website_Click_Through_Rate INT,
	Newsletter_Open_Rate FLOAT,
	Social_Media_Engagement_Score FLOAT,
	Referral_Count INT,
	Account_Age_days INT,
	Feedback_Score INT,
	Product_Return_Rate VARCHAR(10),
	Marketing_Email_Click_Rate FLOAT,
	Subscription_Status INT,
	Product_Upsell_Success INT,
	Customer_Segment_Group VARCHAR(10),
	Interest_in_New_Product VARCHAR(10),
	Income_Level VARCHAR(15)
);


SELECT * FROM E_commerce_retail_data;

		------------------------------------------------Error occcured due not specified 'NULL' in the table

ALTER TABLE E_commerce_retail_data;
ALTER COLUMN Customer_Support_Calls FLOAT NULL;

             ------------------------------------------------ Changed Table Name

SELECT * FROM E_commerce_retail_data_new;


-- 1. What is the average customer satisfaction score?


	SELECT 
		AVG(Csat_score) AS avg_csat_score
	FROM E_commerce_retail_data_new;

-- 2. How many customers have logged in more than 5 times daily?

	SELECT 
		COUNT(Daily_User_Logins) AS customer_log
	FROM E_commerce_retail_data_new
	WHERE 
		Daily_User_Logins > 5;
		

-- 3. Retrieve the count of customers who prefer 'Email' as their communication channel?

	SELECT 
		COUNT(Preferred_Communication_Channel) AS customer_pre_communication
	FROM E_commerce_retail_data_new
	WHERE 
		Preferred_Communication_Channel = 'Email';


-- 4.	Find customers who have returned products.

	SELECT *
	FROM E_commerce_retail_data_new
	WHERE 
		Product_Return_Rate = 1;


-- 5.	What is the total transaction amount recorded?

	SELECT 
		SUM(Transaction_Amount) AS trans_amount
	FROM E_commerce_retail_data_new


-- 6. What is the average session duration for customers who made high-value purchases?



	SELECT 
		High_Value_Purchase_Count,
		AVG(Average_Session_Duration) AS avg_session
	FROM E_commerce_retail_data_new
	GROUP BY High_Value_Purchase_Count
	ORDER BY High_Value_Purchase_Count DESC, avg_session DESC;

			------Gives you multiple average session durations, grouped by how many high-value purchases were made by customers. 
			------The result is more granular, as it shows averages for each level of high-value purchases 

	SELECT 
		AVG(Average_Session_Duration) AS avg_session
	FROM E_commerce_retail_data_new
	WHERE High_Value_Purchase_Count >0;

				-----Gives you a single average session duration for all customers who made any high-value purchase



-- 7.	How many customers responded to surveys and have high product ratings (>=4)?



	SELECT
		COUNT(*)
	FROM E_commerce_retail_data_new
	WHERE Product_Rating IS NOT NULL AND Product_Rating >=4;

	-- If you want to make it clear that you're ignoring NULL values, use the first query (Product_Rating IS NOT NULL AND Product_Rating >= 4).

	-- If you don't care about NULL values and just want to count the rows where Product_Rating >= 4, the second query is enough since NULL values are naturally ignored by the >= comparison.


	SELECT
		COUNT(*)
	FROM E_commerce_retail_data_new
	WHERE Product_Rating >=4;


-- 8.	What is the average response time by membership status ('Yes' or 'No')?


	SELECT
		Membership_Status,
		AVG(Response_Time) AS avg_response_time
	FROM E_commerce_retail_data_new
	GROUP BY Membership_Status
	ORDER BY avg_response_time;


-- 9.  Which product categories are preferred by customers with high social media engagement (score > 80)?
	


	SELECT 
		Product_Category_Preference,
		Social_Media_Engagement_Score
	FROM E_commerce_retail_data_new
	WHERE Social_Media_Engagement_Score > 80
	ORDER BY Social_Media_Engagement_Score DESC;



-- 10.	How many customers have an income level of 'High' and have made successful product upsells?


	SELECT 
		COUNT(*)
	FROM E_commerce_retail_data_new
	WHERE Income_Level = 'High' AND Product_Upsell_Success = 1;


------ ADVANCED LEVEL QUERIES ----



-- 11.	What are the customer segments with the highest average transaction amount? (Using RANK())


WITH Ranked_Segments AS (
	SELECT 
		Customer_Segment_Group,
		AVG(Transaction_Amount) AS avg_trans,
		RANK() OVER (ORDER BY AVG(Transaction_Amount) DESC) AS trans_rank
	FROM E_commerce_retail_data_new
	GROUP BY Customer_Segment_Group
	)

	SELECT 
		Customer_Segment_Group,
		avg_trans
	FROM Ranked_Segments
	WHERE trans_rank >=1;



--12.	Percentage of Customers with a 'Return Product' and 'Low Feedback' using CASE and COUNT()


	SELECT 
	(SUM( 
	CASE WHEN Product_Return_Rate  = 1 AND Feedback_Score < 50 THEN 1 
	ELSE 0 END) * 100.0 / COUNT(*)) AS return_feedback_percentage
	FROM E_commerce_retail_data_new;


--13.	Correlation between Customer Satisfaction and Survey Response Rate using COVAR_POP


SELECT @@VERSION;
						--------- To check the verison of SSMS

COVAR_POP OR CORR             --------- NOT SUPPORTING THIS VERSION

SELECT name AS DatabaseName, state_desc AS State, compatibility_level
FROM sys.databases;


SELECT name, compatibility_level
FROM sys.databases
WHERE name = 'E_commerce_Retail';
									---------- To check the Database compatibility

ALTER DATABASE E_commerce_Retail
SET COMPATIBILITY_LEVEL = 160;
									----------- To Set the Database comptibility



--------------- FIRST METHOD -----------Using a Subquery

WITH Stats AS (
  SELECT 
        AVG(Csat_score) AS AvgCsat,
        AVG(Survey_Response_Rate) AS AvgSurvey,
        COUNT(*) AS CountData
    FROM E_commerce_retail_data_new
)
SELECT 
    SUM((Csat_score - Stats.AvgCsat) * (Survey_Response_Rate - Stats.AvgSurvey)) / Stats.CountData AS Covariance
FROM 
    E_commerce_retail_data_new, Stats
	
GROUP BY CountData;



-------------- SECOND METHOD  ------- Using a Single Query Without CTE


SELECT 
    SUM((Csat_score - AvgCsat) * (Survey_Response_Rate - AvgSurvey)) / NULLIF(CountData, 0) AS Covariance
FROM 
    (SELECT 
        Csat_score, 
        Survey_Response_Rate,
        (SELECT AVG(Csat_score) FROM E_commerce_retail_data_new) AS AvgCsat,
        (SELECT AVG(Survey_Response_Rate) FROM E_commerce_retail_data_new) AS AvgSurvey,
        (SELECT COUNT(*) FROM E_commerce_retail_data_new) AS CountData
     FROM 
        E_commerce_retail_data_new) AS Subquery

	GROUP BY CountData;




-- 14. Customer Support Calls Duration and High Satisfaction using NTILE() for Customer Segmentation


SELECT 
	Csat_score,
	Customer_Support_Calls,
	NTILE(4) OVER ( ORDER BY Customer_Segment_Group DESC) AS Cust_seg_group
FROM E_commerce_retail_data_new
WHERE Csat_score > 80
ORDER BY Csat_score DESC;



-- 15.	Total Transaction Amount by Membership using SUM() and GROUPING SETS


		------ Method -1
SELECT 
	SUM(Transaction_Amount) as sum_tran,
	Membership_Status
FROM E_commerce_retail_data_new
GROUP BY Membership_Status;

		------ Method -2
SELECT Membership_Status, SUM(Transaction_Amount) AS total_transaction_amount
FROM E_commerce_retail_data_new
GROUP BY GROUPING SETS ((Membership_Status));



-- 16.	Preferred Product Categories by Customer Segments using WINDOW FUNCTION


		SELECT 
			Product_Category_Preference,
			Customer_Segment_Group,
			COUNT(*) OVER (PARTITION BY Customer_Segment_Group) AS Cust_seg
		FROM E_commerce_retail_data_new;


--17.	Analyzing Response Times by Communication Channel using LAG() to Track Change


SELECT 
	
	Preferred_Communication_Channel,
	Response_Time,
	LAG(Response_Time) OVER ( PARTITION BY Preferred_Communication_Channel ORDER BY Response_Time) AS Previous_response_time
FROM E_commerce_retail_data_new;




--18.	Top 10 Customers with Most Referrals and High Session Duration using DENSE_RANK()


				----------- use 'TOP' for SQL
				------------use 'LIMIT' for MySQL
	SELECT TOP 10
		Referral_Count,
		Average_Session_Duration,
		DENSE_RANK() OVER (ORDER BY Referral_Count DESC) AS DEK_RANK
	FROM E_commerce_retail_data_new
	WHERE Referral_Count IS NOT NULL
	ORDER BY DEK_RANK;



--19.	Customer Count by Segment and Income Level using GROUP BY CUBE()

		SELECT
			Customer_Segment_Group,
			Income_Level,
			COUNT(*) AS cust_count
		FROM E_commerce_retail_data_new
		GROUP BY Customer_Segment_Group, Income_Level;
												--------------- NORMAL 'GROUP BY'

		SELECT
			Customer_Segment_Group,
			Income_Level,
			COUNT(*) AS cust_count
		FROM E_commerce_retail_data_new
		GROUP BY CUBE(Customer_Segment_Group, Income_Level);
													--------------- 'GROUP BY CUBE'

	---GROUP BY CUBE,
	---which generates additional summary rows (subtotals and grand totals) beyond what the basic GROUP BY query provides.





-- 20.	'Rolling Average' for Customer Satisfaction over Account Age using 'WINDOW FUNCTION'


SELECT * FROM E_commerce_retail_data_new;


	SELECT 
		Csat_score,
		Account_Age_days,
		AVG(Csat_score) OVER (ORDER BY Account_Age_days ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_avg
	FROM E_commerce_retail_data_new
	ORDER BY Account_Age_days;

