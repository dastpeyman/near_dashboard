import os
import argparse
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
from shroomdk import ShroomDK
from pick import pick
import matplotlib.pyplot as plt
import plotly.express as px
import altair as alt

API_KEY = "20b9ccbf-e84a-4bb8-a305-4f8678e6483f"
BASE_URL = "https://api.flipsidecrypto.com"

st.markdown("# Page 2")
st.sidebar.markdown("# Page 2")

sdk = ShroomDK(API_KEY, BASE_URL)


# Load the sql query from a file
active_wallet_sql_query = open("./sql/Total_Weekly_Active.sql", 'r').read()
new_wallet_sql_query = open("./sql/Total_Weekly_New_Wallets.sql", 'r').read()
users_sql_query = open("./sql/Total_Number_Users.sql", 'r').read()
average_users_sql_query = open("./sql/Average_Number_Users.sql", 'r').read()

# Run the query with pagination

page_number = 1
page_size = 10

active_wallet_result_set = sdk.query(
    active_wallet_sql_query, 
    page_size=page_size,
    page_number=page_number)

new_wallet_result_set = sdk.query(
    new_wallet_sql_query, 
    page_size=page_size,
    page_number=page_number)

users_result_set = sdk.query(
    users_sql_query, 
    page_size=page_size,
    page_number=page_number)

average_users_result_set = sdk.query(
    average_users_sql_query, 
    page_size=page_size,
    page_number=page_number)


df_active_wallet = pd.DataFrame(active_wallet_result_set.records)
df_new_wallet = pd.DataFrame(new_wallet_result_set.records)
df_users = pd.DataFrame(users_result_set.records)
df_average_users = pd.DataFrame(average_users_result_set.records)



active_wallet_bar_chart = alt.Chart(df_active_wallet).mark_bar(interpolate='basis').encode(
    alt.X('date', title='Date'),
    alt.Y('total_user', title='Active Wallets'),
    # color='type'

).properties(
    title='Total Weekly Active and New Wallets'
)

new_wallet_line_chart = alt.Chart(df_new_wallet).mark_line(color="#FFAA00",interpolate='basis').encode(
    alt.X('date', title='Date'),
    alt.Y('total_user', title='New Wallets'),
    # color='type'

).properties(
    title='Total Weekly Active and New Wallets'
)

merge_chart = (new_wallet_line_chart + active_wallet_bar_chart).resolve_scale(y='independent').properties(width=600)
st.altair_chart(merge_chart,use_container_width=True)


users_line_chart = alt.Chart(df_users).transform_fold(
    ['user_per_hour', 'user_per_minute', 'user_per_second'],
    as_=['tyep', 'amount']
).mark_line().encode(
    x='date:T',
    y=alt.Y(
        'amount:Q',
        scale=alt.Scale(type="log")),
    color='tyep:N'
)

st.altair_chart(users_line_chart,use_container_width=True)

average_users_bar_chart = alt.Chart(df_average_users).transform_fold(
    ['avg_usr_hour', 'avg_usr_minute', 'avg_usr_second'],
    as_=['user', 'amount']
).mark_bar().encode(
    alt.X('type', title='time'),
    y=alt.Y(
        'amount:Q'),
    color='user:N'
)

st.altair_chart(average_users_bar_chart,use_container_width=True)










