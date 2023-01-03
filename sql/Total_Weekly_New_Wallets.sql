with active as ( select tx_signer, 
count(DISTINCT(tx_hash)) as total_tx
from near.core.fact_transactions
where block_timestamp::date >= '2022-01-01'
group by 1
having total_tx > 50)
,
final as ( select 'Active Wallet' as type, 
trunc(block_timestamp,'week') as weekly,
count(DISTINCT(tx_signer)) as total_user
from near.core.fact_transactions
where tx_signer in (select tx_signer from active)
and block_timestamp::date >= '2022-01-01'
group by 1,2
)

select left(weekly,10) as date, *
from final