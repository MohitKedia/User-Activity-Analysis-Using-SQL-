#Project Title: User Activity Analysis Using SQL 

#This project focuses on analyzing user activity data from two tables, `users_id` and `logins`.
#The goal is to provide valuable insights into user engagement, activity patterns, and 
#overall usage trends over time.

##User Activity Analysis set of questions

use mohitdb
drop table users1
CREATE TABLE users1 (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

drop table logins;
CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP TIMESTAMP NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT
  );
  

INSERT INTO USERS1 VALUES (1, 'Alice', 'Active');
INSERT INTO USERS1 VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS1 VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS1  VALUES (4, 'David', 'Active');
INSERT INTO USERS1  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS1  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS1  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS1  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS1 VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS1 VALUES (10, 'Judy', 'Active');

select * from users1

INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);
INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);

SELECT * FROM users1
SELECT * from logins

##Q1) Which users did not log in during the past 5 months?
##A1)
with cte as 
(select user_id,CURRENT_DATE,login_timestamp,round(Days_diff*1.0/30,2) as Month_diff from
(SELECT user_id,CURRENT_DATE, login_timestamp,DATEDIFF(current_date,login_timestamp) AS Days_diff
from logins) as A)

select user_id,user_name from users1
where user_id not in (SELECT user_id from cte where month_diff <=5)

-------
##Q2) How many users and sessions were there in each quarter, ordered from newest to oldest?

SELECT * from logins

select Years,quarters,count(DISTINCT user_id) user_cnt,count(distinct session_id) session_cnt from
(select *,QUARTER(login_timestamp) quarters, YEAR(login_timestamp) Years from logins) as A
group by 1,2
order by 1 desc,2 desc

##Q3) Which users logged in during January 2024 but did not log in during November 2023?

with cte as 
(Select user_id,MONTH(login_timestamp), YEAR(login_timestamp)
from logins
where MONTH(login_timestamp)= 1 and YEAR(login_timestamp) = 2024),

cte1 as 
(Select user_id,MONTH(login_timestamp),YEAR(login_timestamp)
from logins
where MONTH(login_timestamp) = 11 and YEAR(login_timestamp) = 2023)

select DISTINCT user_id from cte where user_id not in (select user_id from cte1)

##Q4)  What is the percentage change in sessions from the last quarter?

with cte as 
(SELECT QUARTER(login_timestamp) quarters, YEAR(login_timestamp) years,count(session_id) sessions
from logins
group by 1,2
order by 2,1),

cte1 as 
(select quarters,years,sessions,lag(sessions)over(order by years,quarters) prev_quarter_sessions
from cte)

select quarters,years,(sessions-prev_quarter_sessions)*100/prev_quarter_sessions as percent_change
from cte1

##Q5)  Which user had the highest session score each day?

with cte as 
(select user_id,cast(login_timestamp as date) as login_date,sum(session_score) as score
 from logins
 group by 1,2
 order by 2,3)
 
 select user_id,login_date,score from 
 (select * , row_number()over(partition by login_date order by score desc) rn from cte) as B
 where rn=1
 order by login_date

 



