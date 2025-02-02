--CASE STUDY: FRAUDULENT TRANSACTIONS IN THE BANK

select * from fraudulent;

--1. How many transactions occurred per transaction type?
select "type", count(*) from fraudulent
group by "type";

--2. Which Transaction Type has the highest number of Fraudulent Transactions?
select "type", count(*) "no of fraud" from fraudulent
where "isfraud" = 1
group by "type"
order by "no of fraud" desc
limit 1;

--3. What is the average fraudulent transaction amount?
--the CEIL function is used to round up the value to the nearest integer
select ceil(avg("amount")) "average fraud amount" from fraudulent
where "isfraud" = 1;

--4. What is the Maximum fraudulent transaction amount?
select "amount" "max fraud amount" from fraudulent
where "isfraud" = 1
order by "amount" desc
limit 1;

--5. What is the Minimum fraudulent transaction amount?
select "amount" "min fraud amount" from fraudulent
where "isfraud" = 1
order by "amount" asc
limit 1;

--6. Who are the Top 10 customers with the highest amount defrauded?
select "nameorig", sum("amount") "amt defrauded" from fraudulent
where "isfraud" = 1
group by "nameorig"
order by "amt defrauded" desc
limit 10;

--7. How effective is the bank in flagging fraud?

--count of transactions flagged fraud correctly
select count(*) from fraudulent
where "isflaggedfraud" = 1 and "amount" >= 200000; -- 16

--count of fraud transactions not flagged
select count(*) from fraudulent
where "isflaggedfraud" = 0 and "amount" >200000;       -- 10026

--Total transactions that should be flagged fraud
select count(*) from fraudulent
where "amount" >=200000;                               -- 10042



-- How effective is the bank in flagging fraud?
select round((select count(*) from fraudulent
where "isflaggedfraud" = 1 and "amount" >= 200000)*100.0/ (select count(*) from fraudulent
where "amount" >=200000),2);   -- 0.16%


--8. Who are the Top 20 Fraudsters
select "namedest", sum("amount") "amt defrauded" from fraudulent
where "isfraud" = 1
group by "namedest"
order by "amt defrauded" desc
limit 20;

--9. Identify transactions exceeding a certain threshold to spot potential fraud
SELECT transaction_id, amount, nameorig, namedest
FROM transactions
WHERE amount > 10000
ORDER BY amount DESC;

--10.Detect accounts involved in multiple transactions within a short period, which may indicate fraudulent behavior.
SELECT nameorig, namedest, COUNT(*) as transaction_count
FROM transactions
WHERE isfraud = 1
GROUP BY nameorig, namedest
HAVING COUNT(*) > 5
ORDER BY transaction_count DESC;

--11.Find transactions where the origin or destination account balance remains unchanged, which could suggest suspicious activity.
SELECT transaction_id, nameorig, namedest, amount
FROM transactions
WHERE (oldbalanceorg = newbalanceorig) OR (oldbalancedest = newbalancedest);

--12.Identify accounts most frequently flagged for fraud to prioritize monitoring.
SELECT nameorig, COUNT(*) as fraud_count
FROM transactions
WHERE isfraud = 1
GROUP BY nameorig
ORDER BY fraud_count DESC
LIMIT 10;

--13.Analyze the distribution of transaction types in fraudulent activities to detect anomalies.
SELECT type, COUNT(*) as type_count
FROM transactions
WHERE isfraud = 1
GROUP BY type
ORDER BY type_count DESC;







/* CREATING TABLE AND LOADING DATA
create table fraudulent(
step int,
type varchar(20),
amount float,
nameorig varchar(50),
oldbalanceorg float,
newbalanceorig float,
namedest varchar(50),
oldbalancedest float,
newbalancedest float,
isfraud int,
isflaggedfraud int
);

copy public.fraudulent
from 'C:\Users\akann\Downloads\Fraudulent Transactions.csv'
delimiter ',' csv header; */
