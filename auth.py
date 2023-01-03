import os
import argparse
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
from shroomdk import ShroomDK
from pick import pick
import matplotlib.pyplot as plt

API_KEY = "20b9ccbf-e84a-4bb8-a305-4f8678e6483f"
BASE_URL = "https://api.flipsidecrypto.com"


def get_nft_collection(name: str):
    sdk = ShroomDK(API_KEY, BASE_URL)
    sql = f"""
    select 
        distinct project_name, nft_address 
    from ethereum.core.ez_nft_sales 
    where lower(project_name) like '%{name.lower()}%' 
    order by project_name ASC
    """
    # and block_timestamp >= getdate() - interval'48 hours'
    results = sdk.query(sql)
    if len(results.rows) == 0:
        return None

    choice = pick(
        [f'{row[0]} ({row[1]})' for row in results.rows], 
        'Choose a collection: ', 
        indicator='=>', 
        default_index=0
    )
    return results.records[0]


def get_nft_sale_history(nft_address: str):
    sdk = ShroomDK(API_KEY, BASE_URL)
    sql = f"""
    SELECT
        date_trunc('hour', block_timestamp) AS date,
        avg(price) as avg_hourly_eth_price,
        count(1) as num_sales
    FROM ethereum.core.ez_nft_sales 
    WHERE 
        nft_address = LOWER('{nft_address}')
        AND block_timestamp >= GETDATE() - interval'30 day'
    GROUP BY 1
    ORDER BY 1 ASC
    """
    results = sdk.query(sql)
    print(f"retrieved {results.run_stats.record_count} rows in {results.run_stats.elapsed_seconds} seconds")
    return results


def plot(query_result_set, collection):
    # Plot the nft sale history
    # x axis values
    x = [row[0].replace("2022-", "")[:-7] for row in query_result_set.rows]
    
    # corresponding y axis values
    y = [row[1] for row in query_result_set.rows]
    
    # plotting the points 
    plt.plot(x, y, label="ETH Price")
    
    # naming the x axis
    plt.xlabel('Date')
    plt.xticks(rotation = 45)

    # naming the y axis
    plt.ylabel('Average ETH Price')
    
    # giving a title to my graph
    plt.title(f'Hourly Sales for {collection.get("project_name")} ({collection.get("nft_address")})')
    chart_data = pd.DataFrame(
    y,x,columns=['Average ETH Price'])
    # fig, ax = plt.subplots(1,1)
    # ax.scatter(x, y)
    # ax.set_xlabel('Date')
    # ax.set_ylabel('Average ETH Price')
    # st.pyplot(fig)
    st.line_chart(chart_data)
    # function to show the plot
    # plt.show()


 


def run(lookup_id: str):
    if '0x' not in lookup_id:
        collection = get_nft_collection(lookup_id)
        if not collection:
            print("No collection found. Try a different name.")
            return
    else:
        collection = {"project_name": "unknown", "nft_address": lookup_id}

    print(f"fetching nft sales data for `{collection.get('project_name')}` @ `{collection.get('nft_address')}`")

    # Get the nft sale history
    results = get_nft_sale_history(collection.get('nft_address'))

    # Plot the results
    if results.rows and len(results.rows) > 0:
        plot(results, collection)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Retrieve NFT Sales.')
    # parser.add_argument('moonbirds', type=str,  help='NFT Collection Name')
    parser.add_argument('collection_name', type=str,  help='NFT Collection Name')
    parser.add_argument('collection_name', type=str,  help='NFT Collection Name')
    argv = ["cryptopunks","MintedTeddy"]
    # "cryptopunks",
    args = parser.parse_args(argv[0:])
    # args = parser.parse_args(argv[1:])
    run(args.collection_name)

# st.title('Earthquake Data Explorer')
# st.text('This is a web app to allow exploration of Earthquake Data')
# # Initialize `ShroomDK` with your API Key
# sdk = ShroomDK("20b9ccbf-e84a-4bb8-a305-4f8678e6483f")

# # Parameters can be passed into SQL statements 
# # via native string interpolation
# my_address = "0xfB29a45Dc480E9B17f9bb2d1eB175Ad152AFB1eE"
# sql = f"""
#     SELECT 
#     tx_hash
#     FROM ethereum.core.fact_token_transfers
#     WHERE ORIGIN_FROM_ADDRESS = LOWER('{my_address}')
# """

# # Run the query against Flipside's query engine 
# # and await the results
# query_result_set = sdk.query(sql)

# # Iterate over the results
# for record in query_result_set.records:
#     tx_hash = record['tx_hash']
#     print(f"${tx_hash}")

