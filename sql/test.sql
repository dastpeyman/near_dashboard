with active as ( select tx_signer, 
count(DISTINCT(tx_hash)) as total_tx
from near.core.fact_transactions
where block_timestamp::date >= '2022-01-01'
group by 1
having total_tx > 50)
,
new as ( select min(block_timestamp::date) as date, 
tx_signer
from near.core.fact_transactions
group by 2
)
,
new_user as ( select date, tx_signer 
from new 
where date >= '2022-01-01')
,
final as ( select 'Active Wallet' as type, 
trunc(block_timestamp,'week') as weekly,
count(DISTINCT(tx_signer)) as total_user
from near.core.fact_transactions
where tx_signer in (select tx_signer from active)
and block_timestamp::date >= '2022-01-01'
group by 1,2
UNION
select 'New Wallet' as type,
trunc(date,'week') as weekly,
count(DISTINCT(tx_signer)) as total
from new_user 
group by 1,2)

select left(weekly,10) as date, *
from final