with new as ( select min(block_timestamp::date) as date, 
tx_signer
from near.core.fact_transactions
group by 2
)
,
new_user as ( select date, tx_signer 
from new 
where date >= '2022-01-01')
,
final as ( 
select 'New Wallet' as type,
trunc(date,'week') as weekly,
count(DISTINCT(tx_signer)) as total_user
from new_user 
group by 1,2)

select left(weekly,10) as date, *
from final