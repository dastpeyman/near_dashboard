with ethereum_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(amount_usd) as volumes
from ethereum.core.ez_token_transfers
where symbol = 'USDC'
and block_timestamp >= GETDATE() - interval'30 day'
and contract_address = lower('0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48')
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
optimism_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(RAW_AMOUNT/pow(10,6)) as volumes
from optimism.core.fact_token_transfers
where contract_address = lower('0x7f5c764cbc14f9669b88837ca1490cca17c31607')
and block_timestamp >= GETDATE() - interval'30 day'
and raw_amount::float > 0
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
avalanche_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(RAW_AMOUNT/pow(10,6)) as volumes
from avalanche.core.fact_token_transfers
where contract_address = lower('0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e')
and block_timestamp >= GETDATE() - interval'30 day'
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
arbitrum_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(RAW_AMOUNT/pow(10,6)) as volumes
from arbitrum.core.fact_token_transfers
where contract_address = lower('0xff970a61a04b1ca14834a43f5de4533ebddb5cc8')
and block_timestamp >= GETDATE() - interval'30 day'
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
Polygon_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(RAW_AMOUNT/pow(10,6)) as volumes
from polygon.core.fact_token_transfers
where contract_address = lower('0x2791bca1f2de4661ed88a30c99a7a9449aa84174')
and block_timestamp >= GETDATE() - interval'30 day'
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
gnosis_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(RAW_AMOUNT/pow(10,6)) as volumes
from gnosis.core.fact_token_transfers
where contract_address = lower('0xddafbb505ad214d7b80b1f830fccc89b60fb7a83')
and block_timestamp >= GETDATE() - interval'30 day'
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
bsc_user as ( select date(block_timestamp) as date, FROM_ADDRESS, count(DISTINCT(tx_hash)) as total_txx, sum(RAW_AMOUNT/pow(10,18)) as volumes
from bsc.core.fact_token_transfers
where contract_address = lower('0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d')
and block_timestamp >= GETDATE() - interval'30 day'
and origin_from_address != '0x0000000000000000000000000000000000000000'
and origin_to_address != '0x0000000000000000000000000000000000000000'
and from_address != '0x0000000000000000000000000000000000000000'
and to_address != '0x0000000000000000000000000000000000000000'
group by 1,2)
,
algorand_user as ( select date(block_timestamp) as date, TX_SENDER as from_address, count(DISTINCT(tx_id)) as total_txx, sum(AMOUNT) as volumes
from algorand.core.ez_transfer
where asset_id = '31566704'
and block_timestamp >= GETDATE() - interval'30 day'
group by 1,2)
,
solana_user as ( select date(block_timestamp) as date, tx_from as from_address, count(DISTINCT(tx_id)) as total_txx, sum(AMOUNT) as volumes
from solana.core.fact_transfers
where mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'
and block_timestamp >= GETDATE() - interval'30 day'
group by 1,2)
,
Axelar_user as ( select date(block_timestamp) as date, sender as from_address, count(DISTINCT(tx_id)) as total_tx, sum(amount/pow(10,6)) as volumes
from axelar.core.fact_transfers
where currency = 'uusdc'
and block_timestamp >= GETDATE() - interval'30 day'
group by 1,2)
,
Flow_user as ( select date(block_timestamp) as date, event_data:from as from_address, count(DISTINCT(tx_id)) as total_txx, sum((event_data:amount)::float) as volumes
from flow.core.fact_events
where event_contract = 'A.b19436aae4d94622.FiatToken'
and event_type = 'TokensWithdrawn'
and block_timestamp >= GETDATE() - interval'30 day'
group by 1,2)
,
osmosis_user as ( select date(block_timestamp) as date, SENDER as from_address, count(DISTINCT(tx_id)) as total_txx, sum(AMOUNT/pow(10,decimal)) as volumes
from osmosis.core.fact_transfers
where currency in ('ibc/D189335C6E4A68B513C10AB227BF1C1D38C746766278BA3EEB4FB14124F1D858', 'uusdc')
and block_timestamp >= GETDATE() - interval'30 day'
group by 1,2)
,
-- Near Credited to #Yousefi_1994
near_user as ( select date(block_timestamp) as date, split(logs[0], ' ')[3]::string as from_address,
count(DISTINCT(tx_hash)) as total_txx, sum((split(logs[0], ' ')[1] / pow(10, 6))::float) as volumes
from near.core.fact_receipts
where receiver_id = 'a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48.factory.bridge.near'
and logs[0] is not null 
and split(logs[0], ' ')[1] > 0 and split(logs[0], ' ')[1] is not null
and logs[0] like 'Transfer%from%to%'
and block_timestamp >= GETDATE() - interval'30 day'
group by 1,2)
,
all_chains as ( select 'Ethereum' as chain, *
from ethereum_user
UNION
select 'Optimism' as chain, *
from optimism_user 
UNION
select 'Arbitrum' as chain, *
from arbitrum_user
UNION
select 'Polygon' as chain, *
from polygon_user
UNION
select 'BSC' as chain, *
from bsc_user
UNION
select 'Near' as chain, *
from near_user
UNION
select 'Solana' as chain, *
from solana_user
UNION
select 'Osmosis' as chain, *
from osmosis_user
UNION
select 'Flow' as chain, *
from flow_user
UNION
select 'Axelar' as chain, *
from axelar_user
UNION
select 'Gnosis' as chain, *
from gnosis_user
UNION
select 'Avalanche' as chain, *
from avalanche_user
UNION
select 'Algorand' as chain, *
from algorand_user )
,
All_Chain as ( select *
from all_chains 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null
and from_address not in ('F8Vyqk3unwxkXukZFQeYyGmFfTG3CAX4v24iyrjEYBJV','3uTzTX5GBSfbW7eM9R9k95H7Txe32Qw3Z25MtyD2dzwC',  
'FGBvMAu88q9d1Csz7ZECB5a2gbWwp6qicNxN2Mo7QhWG', 'FG3z1H2BBsf5ekEAxSc1K6DERuAuiXpSdUGkYecQrP5v', 'GVV4ZT9pccwy9d17STafFDuiSqFbXuRTdvKQ1zJX6ttX', 
'9BVcYqEQxyccuwznvxXqDkSJFavvTyheiTYk231T1A8S','CuieVDEDtLo7FypA9SbLM9saXFdb1dsshEkyErMqkRQq','5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1', 
'FmhXe9uG6zun49p222xt3nG1rBAkWvzVz7dxERQ6ouGw' ))
,
Ethereum as ( select 'Ethereum' as chain, *
from ethereum_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Optimism as ( select 'Optimism' as chain, *
from optimism_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Arbitrum as ( select 'Arbitrum' as chain, *
from arbitrum_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Polygon as ( select 'Polygon' as chain, *
from polygon_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
BSC as ( select 'BSC' as chain, *
from bsc_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null)
,
Gnosis as ( select 'Gnosis' as chain, *
from Gnosis_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Avalanche as ( select 'Avalanche' as chain,*
from avalanche_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Solana as ( select 'Solana' as chain, *
from solana_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null
and from_address not in ('F8Vyqk3unwxkXukZFQeYyGmFfTG3CAX4v24iyrjEYBJV','3uTzTX5GBSfbW7eM9R9k95H7Txe32Qw3Z25MtyD2dzwC',  
'FGBvMAu88q9d1Csz7ZECB5a2gbWwp6qicNxN2Mo7QhWG', 'FG3z1H2BBsf5ekEAxSc1K6DERuAuiXpSdUGkYecQrP5v', 'GVV4ZT9pccwy9d17STafFDuiSqFbXuRTdvKQ1zJX6ttX', 
'9BVcYqEQxyccuwznvxXqDkSJFavvTyheiTYk231T1A8S','CuieVDEDtLo7FypA9SbLM9saXFdb1dsshEkyErMqkRQq','5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1', 
'FmhXe9uG6zun49p222xt3nG1rBAkWvzVz7dxERQ6ouGw' )) 
,
Flow as ( select 'Flow' as chain, *
from flow_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Near as ( select 'Near' as chain, *
from near_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Osmosis as ( select 'Osmosis' as chain, *
from osmosis_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Algorand as ( select 'Algorand' as chain, *
from algorand_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null)
,
Optimism as ( select 'Optimism' as chain, *
from optimism_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null) 
,
Axelar as ( select 'Axelar' as chain, *
from axelar_user 
where from_address not in ( select address from crosschain.core.address_labels
where label_type in ('dex','defi'))
and volumes > 0
and volumes is not null)

select date, chain, count(DISTINCT(from_address)) as total_users, avg(total_txx) as avg_tx, avg(volumes) as avg_volume_user,
sum(total_txx) as total_tx, sum(volumes) as total_volume,
sum(total_volume) over (partition by chain order by date asc) as cum_volume,
sum(total_tx) over (partition by chain order by date asc) as cum_tx
from Optimism
where date < CURRENT_DATE
and from_address <> '0x0000000000000000000000000000000000000000'
group by 1,2
order by 1