#Write a sql query to find repeat and new customers

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),
								  (2,200,cast('2022-01-01' as date),2500),
                                  (3,300,cast('2022-01-01' as date),2100),
								  (4,100,cast('2022-01-02' as date),2000),
                                  (5,400,cast('2022-01-02' as date),2200),
                                  (6,500,cast('2022-01-02' as date),2700),
                                  (7,100,cast('2022-01-03' as date),3000),
                                  (8,400,cast('2022-01-03' as date),1000),
                                  (9,600,cast('2022-01-03' as date),3000);

with first_visit_date as (
SELECT 
    customer_id, MIN(order_date) AS first_visit
FROM
    customer_orders
GROUP BY customer_id)
SELECT 
    co.order_date,
    sum(case when co.order_date=fd.first_visit then 1 else 0 end) as new_customers_count,
	sum(case when co.order_date!=fd.first_visit then 1 else 0 end) as repeat_customers_count
FROM
    customer_orders co
        INNER JOIN
    first_visit_date fd ON co.customer_id = fd.customer_id
group by co.order_date;



#Write a query to find visits  and group resources
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries values ('A','Bangalore','A@gmail.com',1,'CPU'),
                           ('A','Bangalore','A1@gmail.com',1,'CPU'),
                           ('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
                           ('B','Bangalore','B@gmail.com',2,'DESKTOP'),
                           ('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
                           ('B','Bangalore','B2@gmail.com',1,'MONITOR');
with visits as (
SELECT 
    name, floor, COUNT(floor) AS no_of_floor_visits, rank() over(partition by name order by count(floor) desc) as rnk
FROM
    entries
GROUP BY name , floor),
resources_details as (
SELECT 
    name, COUNT(*) AS total_visits, GROUP_CONCAT(resources) as resources
FROM
    entries
GROUP BY name)
SELECT 
    r.name,
    r.total_visits,
    r.resources,
    v.floor AS most_visited_floor
FROM
    resources_details r
        JOIN
    visits v ON v.name = r.name
WHERE
    rnk = 1;



#Write a query to find matches_played, total_wins , total_losses

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);

INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

with teams as (
select team_1 as team from icc_world_cup
union
select team_2 as team from icc_world_cup)
SELECT 
    t.team, 
    count(*) AS matches_played,
    sum(case when d.winner=t.team then 1 else 0 end) as total_wins,
    sum(case when d.winner!=t.team then 1 else 0 end) as total_losses,
	sum(case when d.winner=t.team then 1 else 0 end)*2 as total_points
FROM
    teams t
        JOIN
    icc_world_cup d ON t.team = d.team_1 OR t.team = d.team_2
GROUP BY t.team
order by total_points desc,t.team asc;



#Write a query tp find nth occurence of sunday in future 

SET @today_date = '2026-10-09';
SET @n = 3;

SELECT 
    DATE_ADD(@today_date,
        INTERVAL (8 - DAYOFWEEK(@today_date) % 7 + 7 * (@n - 1)) DAY) AS Nth_Sunday;
        
        
#Write a query to find Personid, Name, number of friends, sum of marks of person who have friends with total score greater then 100

Create table friend (pid int, fid int);

insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');

create table person (PersonID int,	Name varchar(50),	Score int);


insert into person(PersonID,Name ,Score) values('1','Alice','88');
insert into person(PersonID,Name ,Score) values('2','Bob','11');
insert into person(PersonID,Name ,Score) values('3','Devis','27');
insert into person(PersonID,Name ,Score) values('4','Tara','45');
insert into person(PersonID,Name ,Score) values('5','John','63');
with score_details as (
SELECT 
    f.pid,
    SUM(p.score) AS total_frnds_score,
    COUNT(*) AS total_frnds
FROM
    person p
        INNER JOIN
    friend f ON f.fid = p.personid
GROUP BY f.pid)
SELECT 
    s.pid, p.name, s.total_frnds_score, s.total_frnds
FROM
    score_details s
        INNER JOIN
    person p ON p.personid = s.pid
WHERE s.total_frnds_score>100;


#Write a sql query to find the cancellation rate of requests with banned users (both client and driver not be banned)
#each day between "2013-10-01" to "2013-10-03". round cancellation rate to two  decimals points.

Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));


insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');


Create table Users (users_id int, banned varchar(50), role varchar(50));

insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

SELECT 
    t.request_at,
    count(*) as total_trips,
    sum(case when t.status in ('cancelled_by_client','cancelled_by_driver') then 1 else 0 end) as cancelled_trips,
    round(sum(case when t.status in ('cancelled_by_client','cancelled_by_driver') then 1 else 0 end)/count(*),2)*100 as cancellation_rate
FROM
    trips t
        JOIN
    users c ON c.users_id = t.client_id
        JOIN
    users d ON t.driver_id = d.users_id
WHERE
    (t.request_at between '2013-10-01' and '2013-10-03') and c.banned = 'No' AND d.banned = 'No'
group by t.request_at;


#Write an sql query to find winner in each group 
#The winner in each group is the  player who scored the maximum points within the group 
#In case of tie the lowest player_id wins


create table players
(player_id int,
group_id int);


insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

with player_score as (
select first_player as player_id, first_score as score from matches
union all 
select second_player as player_id, second_score as score from matches),
final_score as (
SELECT 
    p.group_id, ps.player_id, SUM(ps.score) AS score
FROM
    player_score ps
        JOIN
    players p ON ps.player_id = p.player_id
GROUP BY p.group_id , ps.player_id),
rank_details as (select *, rank() over(partition by group_id order by score desc, player_id asc) as ranks from final_score)
select * from rank_details where ranks=1;


#Write an SQL query to find for each seller, whether the brand of the second item(by date)
#they is their favorite brand
#if the seller sold less then two items, report the answer for that seller as no 
create table user (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table cus_orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into user values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into cus_orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

with rank_details as (
select *, 
       rank() over(partition by seller_id order by order_date ) as rn 
from cus_orders)
SELECT 
    u.user_id as seller_id,
    rd.order_id , 
    rd.order_date,
    i.item_brand,
    u.favorite_brand, 
    case when  i.item_brand = u.favorite_brand then 'yes' else 'no' end as fav_status
FROM user u left join
    rank_details rd on rd.seller_id=u.user_id and rd.rn=2
   left join 
    items i ON rd.item_id = i.item_id;
    

 #Wrie an SQL query to group dates as start_date and end_date with status
 
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success') ;

with all_dates as (
SELECT date_value,state,
    ROW_NUMBER() OVER (
        PARTITION BY state
        ORDER BY date_value
    ) AS rn,
    DATE_ADD(
        date_value,
        INTERVAL -ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY date_value
        ) DAY
    ) AS group_date
FROM tasks
ORDER BY date_value)
SELECT 
    MIN(date_value) AS start_date,
    MAX(date_value) AS end_date,
    state
FROM
    all_dates
GROUP BY group_date , state;


#Write an SQL qyery to find total number of users and the total amount spent using mobile only , desktop only 
#and both mobile and desktop together for each date


create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

with all_spend as (
select user_id,spend_date,max(platform) as platform,sum(amount) as amount
from spending
group by user_id,spend_date
having count(distinct platform)=1
union all
select user_id,spend_date,'both' as platform,sum(amount) as amount
from spending
group by user_id,spend_date
having count(distinct platform)=2
union all
select null as user_id,spend_date,'both' as platform,0 as amount
from spending )

select spend_date,platform,sum(amount) as amount, count(distinct user_id) as total_users
from all_spend
group by spend_date,platform
order by spend_date,platform desc;



#Write an SQL query to find year wise total sales for each product

create table sales_1(
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales_1 values(1,'2019-01-25','2019-02-28',100),
                        (2,'2018-12-01','2020-01-01',10),
                        (3,'2019-12-01','2020-01-31',1);

with recursive dates as (
select min(period_start) as min_date,max(period_end) as max_date from sales_1
union all
select date_add(min_date,interval 1 day) as min_date, max_date from dates where min_date<max_date)
       
select s.product_id,
       year(d.min_date) as report_year,
       sum(s.average_daily_sales) as total_sales
 from dates d inner join sales_1 s  on d.min_date between s.period_start and s.period_end 
 group by s.product_id,year(d.min_date)
 order by s.product_id, year(d.min_date);
    


#write a sql query to -recommendation system based on -product pairs most commonly purchased together
create table orders_s
(
order_id int,
customer_id int,
product_id int
);

insert into orders_s VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products_s (
id int,
name varchar(10)
);
insert into products_s VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

SELECT 
    concat(pr1.name," ", pr2.name) as products_pair, COUNT(*) AS purchase_frequency
FROM
    orders_s o1
        INNER JOIN
    orders_s o2 ON o1.order_id = o2.order_id
        INNER JOIN
    products_s pr1 ON pr1.id = o1.product_id
        INNER JOIN
    products_s pr2 ON pr2.id = o2.product_id
WHERE
    o1.product_id < o2.product_id
GROUP BY pr1.name , pr2.name;


#Prime subsrciption rate by product action
#Given the following two tables , return the fraction of users, rounded to two decimal places,
#who accessed amzon music and upgraded to prime membership within the first 30 days of signing  update

create table users_a
(
user_id integer,
name varchar(20),
join_date date
);

insert into users_a values
(1, 'Jon', '20-2-14'), 
(2, 'Jane', '20-2-14'), 
(3, 'Jill', '20-2-15'), 
(4, 'Josh', '20-2-15'), 
(5, 'Jean', '20-2-16'), 
(6, 'Justin','20-2-17'),
(7, 'Jeremy', '20-2-18');

create table events_a
(
user_id integer,
type varchar(10),
access_date date
);

insert into events_a values
(1, 'Pay', '20-3-1'), 
(2, 'Music', '20-3-2'), 
(2, 'P', '20-3-12'),
(3, 'Music', '20-3-15'), 
(4, 'Music', '20-3-15'), 
(1, 'P', '20-3-16'), 
(3, 'P', '20-3-22');

SELECT 
    #u.*,e.type,e.access_date,datediff(e.access_date,u.join_date) as no_of_days
    count(distinct u.user_id) as total_users,
    count(distinct case when datediff(e.access_date,u.join_date)<=30 then u.user_id end) as no_prime_subs,
    count(distinct case when datediff(e.access_date,u.join_date)<=30 then u.user_id end)/count(distinct u.user_id)*100 as percentage
    
FROM
    users_a u
        LEFT JOIN
    events_a e ON u.user_id = e.user_id AND e.type = 'P'
WHERE
    u.user_id IN (SELECT 
            user_id
        FROM
            events_a
        WHERE
            type = 'Music');


#customer retention and customer churn metrics
#customer retention refers to a comapny's ability to turn customers into repeat buyers and prevent them from switching to a competitor
#It indicates wheather your product and the quality of your service please your exisiting customers 
#reward programs (cc companies)
#wallet cashback (paytm/gpay)
#zomato pro / swiggy super


create table transactions_r(
order_id int,
cust_id int,
order_date date,
amount int
);
insert into transactions_r values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150);

SELECT 
    MONTH(t1.order_date) AS month,
    COUNT(distinct t2.cust_id) AS repeat_cus
FROM
    transactions_r t1
        LEFT JOIN
    transactions_r t2 ON t1.cust_id = t2.cust_id
        AND TIMESTAMPDIFF(MONTH,
        t2.order_date,
        t1.order_date) = 1
group by MONTH(t1.order_date);


#customer churn
SELECT 
    MONTH(t2.order_date) AS month,
    COUNT(DISTINCT t2.cust_id) AS cus_count
FROM
    transactions_r t2
        LEFT JOIN
    transactions_r t1 ON t1.cust_id = t2.cust_id
        AND TIMESTAMPDIFF(MONTH,
        t2.order_date,
        t1.order_date) = 1
WHERE t1.order_date IS NULL
GROUP BY MONTH(t2.order_date);


# Write a sql query to find second most recent activity and if user has only 1 activoty then return that as it is.
# We will use SQL window functions to solve this problem.

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

with cte as(
select * , 
	   count(*) over(partition by username) as total_activities,
       row_number() over(partition by username order by startdate) as rnk 
from useractivity) 
select username, activity ,rnk ,total_activities from cte where rnk=2 or total_activities=1;



#Write  a SQL query to find total charges as per billing rate

create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);

insert into billings values
('Sachin','1990-01-01',25)
,('Sehwag' ,'1989-01-01', 15)
,('Dhoni' ,'1989-01-01', 20)
,('Sachin' ,'1991-02-05', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values
('Sachin', '1990-07-01' ,3)
,('Sachin', '1990-08-01', 5)
,('Sehwag','1990-07-01', 2)
,('Sachin','1991-07-01', 4);


with daterange as (
select emp_name,
	   bill_date,bill_rate,
       lead(date_sub(bill_date,interval 1 day),1,'9999-12-31') over(partition by emp_name order by bill_date asc) as bill_date_end 
from billings)
SELECT 
    dr.emp_name, SUM(dr.bill_rate * bill_hrs) AS total_charges
FROM
    daterange dr
        INNER JOIN
    hoursworked hw ON dr.emp_name = hw.emp_name
        AND hw.work_date BETWEEN dr.bill_date AND dr.bill_date_end
group by dr.emp_name;



#Write SQL query to find total active users each day, Weekly active users, same day install and purchase, country wise paid users

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);

insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

#find total active users each day
SELECT 
    event_date, COUNT(DISTINCT user_id) AS total_active_users
FROM
    activity
GROUP BY event_date;


#find total active users  each week
SELECT 
    WEEK(event_date) AS week_num,
    COUNT(DISTINCT user_id) total_actives_users
FROM
    activity
GROUP BY WEEK(event_date);


#No_of_users_purchase on same day 
SELECT 
    a1.event_date,
    COUNT(DISTINCT CASE
            WHEN a1.event_date = a2.event_date THEN a1.user_id
        END) AS total_users_purchased_on_same_day
FROM
    activity a1
        LEFT JOIN
    activity a2 ON a1.user_id = a2.user_id
        AND a1.event_name < a2.event_name
GROUP BY a1.event_date;




#percentage of paid users in india, USA and any other  country shiuld be tagged as others
with country_purchase_customers as(
SELECT 
    CASE
        WHEN country IN ('india' , 'usa') THEN country
        ELSE 'others'
    END AS new_country,
    COUNT(distinct user_id) as purchase_cus
FROM
    activity
WHERE
    event_name = 'app-purchase'
GROUP BY 1)
SELECT 
    new_country,
    ROUND(purchase_cus / (SELECT 
                    COUNT(*)
                FROM
                    activity
                WHERE
                    event_name = 'app-purchase') * 100,
            2) AS percentage
FROM
    country_purchase_customers;
    
    

#Among all the users who installed the app on a given day, how many did in app purchased on the very next day 
#day wise result
with prev_event as(
select *,
	   lag(event_name,1) over(partition by user_id order by event_date) as prev_event_name,
       lag(event_date,1) over(partition by user_id order by event_date) as prev_date
from activity)
SELECT 
    event_date,
    SUM(CASE
        WHEN
            event_date = prev_date + 1
                AND event_name = 'app-purchase'
                AND prev_event_name = 'app-installed'
        THEN
            1
        ELSE 0
    END) AS no_of_cus
FROM
    prev_event
GROUP BY 1;
 


#Write a SQL query to find 3 or more consecutive empty seats 

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

#Using lead and lag window_functions
select * from (
select *,
       lag(is_empty,1) over(order by seat_no) as prev_1,
       lag(is_empty,2) over(order by seat_no) as prev_2,
       lead(is_empty,1) over(order by seat_no) as next_1,
       lead(is_empty,2) over(order by seat_no) as next_2
from bms) a 
where is_empty='Y' and prev_1='Y' and prev_2='Y'
or (is_empty='Y' and prev_1='Y' and next_1='Y')
or (is_empty='Y' and next_1='Y' and next_2='Y')
order by seat_no;

#method 2 advanced aggregation 
select * from(
select *,
       sum(case when is_empty='Y' then 1 else 0 end) over(order by seat_no rows between 2 preceding and current row) as prev_2,
       sum(case when is_empty='Y' then 1 else 0 end) over(order by seat_no rows between 1 preceding and 1 following) as prev_next_1,
       sum(case when is_empty='Y' then 1 else 0 end) over(order by seat_no rows between  current row and 2 following) as next_2
from bms) a 
where is_empty='Y' and prev_2=3
or prev_next_1=3
or  next_2=3
order by seat_no;

#method 3 using window_function row_number
with seat_groups as(
select *,
	   row_number() over(order by seat_no)as rnk,
        seat_no-row_number() over(order by seat_no)as diff
from bms where is_empty='Y'),
cnt as (
select diff,
       count(*)  as cn 
from seat_groups group by diff having count(*)>=3)
SELECT 
    *
FROM
    seat_groups
WHERE
    diff IN (SELECT 
            diff
        FROM
            cnt);




#Write a SQL query to find the missing quarter for each store

CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);


SELECT 
    store,
    CONCAT('Q', CAST(10 - SUM(CAST(RIGHT(quarter, 1) AS UNSIGNED)) AS CHAR(2))) AS missing_quarter
FROM
    stores
GROUP BY 1;


#Write a SQL query to find  students with same  marks in physics and chemistry

CREATE TABLE exams (
    student_id INT,
    subject VARCHAR(20),
    marks INT
);

insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);
insert into exams values (5,'Chemistry',99),(5,'Physics',99);

SELECT 
    student_id
FROM
    exams
WHERE
    subject IN ('physics' , 'chemistry')
GROUP BY student_id
HAVING COUNT(DISTINCT subject) = 2
    AND COUNT(DISTINCT marks) = 1;
    

#Write a SQL query to find cities where the  covid cases are increasing continuosly
    
CREATE TABLE covid (
    city VARCHAR(50),
    days DATE,
    cases INT
);

insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);
insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);
insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);
insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);

WITH case_details AS (
    SELECT *,
           LAG(cases) OVER (
               PARTITION BY city
               ORDER BY days
           ) AS previous_cases
    FROM covid
)
SELECT city
FROM case_details
GROUP BY city
HAVING SUM(
    CASE
        WHEN previous_cases IS NOT NULL
             AND cases <= previous_cases
        THEN 1
        ELSE 0
    END
) = 0;


#Write a SQL query to find companies who have atleast 2 users who speaks English and German both languages

create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

SELECT DISTINCT
    company_id
FROM
    (SELECT 
        company_id, user_id, COUNT(*) AS no_of_languages
    FROM
        company_users
    WHERE
        language IN ('English' , 'German')
    GROUP BY company_id , user_id
    HAVING COUNT(*) = 2) t
GROUP BY company_id
HAVING COUNT(DISTINCT user_id) >= 2;



#find how many products falls into customer budget along with list of products
#in case of clash choose the less costly product

CREATE TABLE products_cost (
    product_id VARCHAR(20),
    cost INT
);
insert into products_cost values ("P1",200),("P2",300),("P3",500),("P4",800);

CREATE TABLE customer_budget (
    customer_id INT,
    budget INT
);

insert into customer_budget values (100,400),(200,800),(300,1500);

with running_sum as(
select *,
       sum(cost) over(order by cost asc) as r_sum 
from products_cost)
SELECT 
    cb.customer_id,
    cb.budget,
    COUNT(rs.product_id) AS no_of_products,
    group_concat(rs.product_id,'') AS products
FROM
    customer_budget cb
        LEFT JOIN
    running_sum rs ON cb.budget > rs.r_sum
GROUP BY 1,2;




#find total number of messages exchanged between each user per day

CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

WITH sms_details as (
SELECT sms_date,
       CASE WHEN sender<receiver THEN sender else receiver END person1,
	   CASE WHEN sender>receiver THEN sender else receiver END AS person2,
       sms_no
FROM subscriber)
SELECT sms_date, person1, person2, SUM(sms_no) AS total_sms FROM sms_details GROUP BY sms_date, person1, person2;