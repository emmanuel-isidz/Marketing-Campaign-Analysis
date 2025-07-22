create database marketing_campaign;

-- DATA CLEANING AND PREPARATION
select * from campaigns_detailed;
select * from customers_detailed;
select * from interactions_detailed;
select * from products_detailed;
select * from purchases_detailed;
-- describe each table to check datatypes
describe campaigns_detailed;
describe customers_detailed;
describe interactions_detailed;
describe products_detailed;
describe purchases_detailed;
-- converting to appropriate datatypes
update campaigns_detailed
set start_date = str_to_date(start_date,'%Y-%m-%d'),
	end_date = str_to_date(end_date,'%Y-%m-%d');
alter table campaigns_detailed
modify column start_date date,
modify column end_date date;

update customers_detailed
set signup_date = str_to_date(signup_date,'%Y-%m-%d');
alter table customers_detailed
modify column signup_date date;

update interactions_detailed
set date = str_to_date(date,'%Y-%m-%d');
alter table interactions_detailed
modify column date date;

update purchases_detailed
set date = str_to_date(date,'%Y-%m-%d');
alter table purchases_detailed
modify column date date;

-- standardize table names 
alter table campaigns_detailed
rename to campaigns;
alter table customers_detailed
rename to customers;
alter table interactions_detailed
rename to interactions;
alter table products_detailed
rename to products;
alter table purchases_detailed
rename to purchases;

select * from campaigns;

-- checking for null values
SELECT COUNT(*) FROM customers WHERE name IS NULL OR gender IS NULL OR age IS NULL;
SELECT COUNT(*) FROM purchases WHERE amount_usd IS NULL;


-- EXPLORATORY DATA ANALYSIS (EDA)
-- gender distribution
SELECT gender, COUNT(*) AS count 
FROM customers 
GROUP BY gender;
-- age distribution
SELECT MIN(age) min, MAX(age) max, AVG(age) average
FROM customers;
-- campaign interactions
SELECT c.campaign_name, COUNT(*) AS interactions 
FROM interactions i
join campaigns c on i.campaign_id= c.campaign_id
GROUP BY c.campaign_name
ORDER BY interactions DESC;
-- revenue per campaign
SELECT campaign_id, SUM(amount_usd) AS total_revenue 
FROM purchases 
GROUP BY campaign_id 
ORDER BY total_revenue DESC;

-- RELATIONSHIP ANALYSIS
-- conversion rate per campaign
SELECT 
  i.campaign_id,
  COUNT(DISTINCT i.customer_id) AS total_interactions,
  COUNT(DISTINCT p.customer_id) AS total_purchases,
  ROUND(COUNT(DISTINCT p.customer_id) / COUNT(DISTINCT i.customer_id), 2) AS conversion_rate
FROM interactions i
LEFT JOIN purchases p ON i.customer_id = p.customer_id AND i.campaign_id = p.campaign_id
GROUP BY i.campaign_id;

-- cost per acquisition(cpa)
SELECT 
  c.campaign_id,
  c.cost_usd,
  COUNT(DISTINCT p.customer_id) AS buyers,
  ROUND(c.cost_usd / NULLIF(COUNT(DISTINCT p.customer_id), 0), 2) AS cost_per_acquisition
FROM campaigns c
LEFT JOIN purchases p ON c.campaign_id = p.campaign_id
GROUP BY c.campaign_id, c.cost_usd;

-- ROI per campaign
SELECT 
  c.campaign_id,
  SUM(p.amount_usd) AS total_revenue,
  c.cost_usd,
  ROUND(((SUM(p.amount_usd) - c.cost_usd) / c.cost_usd)*100, 2) AS roi
FROM campaigns c
JOIN purchases p ON c.campaign_id = p.campaign_id
GROUP BY c.campaign_id,c.cost_usd;
-- we are actually making losses as our ROI are all below 1%

-- SEGMENTATION ANALYSIS
-- purchases by gender
SELECT cu.gender, SUM(p.amount_usd) AS revenue
FROM customers cu
JOIN purchases p ON cu.customer_id = p.customer_id
GROUP BY cu.gender;

-- purchases by age group
SELECT 
  CASE 
    WHEN age < 25 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+' 
  END AS age_group,
  COUNT(*) AS total_customers,
  SUM(p.amount_usd) AS total_spent
FROM customers cu
JOIN purchases p ON cu.customer_id = p.customer_id
GROUP BY age_group;
-- customers within the age group of 25-34 interact more with the camapigns which lead to higher revenue
-- male customers account for higher revenue *recommendations- male targetted ads would be advised

-- TIMEBASED TRENDS
-- daily purchases
SELECT DATE(date) AS purchase_date, SUM(amount_usd) AS daily_revenue
FROM purchases
GROUP BY DATE(date)
ORDER BY purchase_date;

-- Customer Sign-Ups Over Time
SELECT DATE(signup_date) AS date, COUNT(*) AS signups
FROM customers
GROUP BY DATE(signup_date)
ORDER BY date;

-- campaign performance analysis
SELECT campaign_id, COUNT(*) AS total_interactions
FROM interactions
GROUP BY campaign_id;

SELECT campaign_id, COUNT(*) AS total_purchases
FROM purchases
GROUP BY campaign_id;

-- this shows that all campaigns had equal interactions but CAMO1 had highest conversion(purchases) which may suggest higher-quality targeting
-- conversion rate analysis
SELECT * FROM campaigns;
SELECT 
    i.campaign_id,
    COUNT(DISTINCT i.customer_id) AS total_interactions,
    COUNT(DISTINCT p.customer_id) AS total_conversions,
    concat(ROUND((COUNT(DISTINCT p.customer_id) / COUNT(DISTINCT i.customer_id))*100, 2),'%') AS conversion_rate
FROM interactions i
LEFT JOIN purchases p 
    ON i.customer_id = p.customer_id AND i.campaign_id = p.campaign_id
GROUP BY i.campaign_id;
-- this shows that CAMO1(email campaign) had a 40% conversion rate about double that of other campaigns

-- REVENUE BY CAMPAIGN COMPARISON ANALYSIS 
SELECT campaign_id, SUM(amount_usd) AS total_revenue
FROM purchases
GROUP BY campaign_id;
-- CAMO1(EMAIL CAMPAIGN) had the highest revenue generated 
-- CAMO2(FACEBOOK ADS) had equal interactions with other campaigns but generated the least revenue and also had the highest cost 

 -- Review Engagement by Channel
 SELECT 
    c.channel,
    COUNT(DISTINCT i.customer_id) AS total_interactions,
    COUNT(DISTINCT p.customer_id) AS total_conversions,
    ROUND(COUNT(DISTINCT p.customer_id) / COUNT(DISTINCT i.customer_id), 2) AS conversion_rate
FROM campaigns c
LEFT JOIN interactions i ON c.campaign_id = i.campaign_id
LEFT JOIN purchases p ON i.customer_id = p.customer_id AND i.campaign_id = p.campaign_id
GROUP BY c.channel;
-- email campaigns have higher conversion rate  to the other campaigns *recommendations -focus more on email campaigns

-- Campaign Timing vs Purchases
SELECT DATE(p.date) AS purchase_day, COUNT(*) AS num_purchases
FROM purchases p
GROUP BY DATE(p.date)
ORDER BY purchase_day desc;








