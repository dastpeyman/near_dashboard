with users as ( select date(block_timestamp) as date, 
count(DISTINCT(tx_hash)) as total, 
count(DISTINCT(TX_SIGNER)) as total_user,
total/24 as tx_per_hour , 
total/1440 as tx_per_minute,  
total/86400 as tx_per_second,
total_user/24 as user_per_hour ,  
total_user/1440 as user_per_minute,  
total_user/86400 as user_per_second
from near.core.fact_transactions
where block_timestamp::date >= '2022-01-01'
and tx_status = 'Success'
group by 1)

select  'Jan-June' as type, 
avg(user_per_hour) as avg_usr_hour,
avg(user_per_minute) as avg_usr_minute,
avg(user_per_second) as avg_usr_second
from users 
where date < '2022-07-01'
group by 1
UNION
select  'July-December' as type, 
avg(user_per_hour) as avg_usr_hour,
avg(user_per_minute) as avg_usr_minute,
avg(user_per_second) as avg_usr_second
from users 
where date > '2022-07-01'
group by 1