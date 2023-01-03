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


st.markdown("# Main page")
st.sidebar.markdown("# Main page")

sdk = ShroomDK(API_KEY, BASE_URL)


# Load the sql query from a file
leaderboard_sql_query = open("./sql/xmetric.sql", 'r').read()

# Run the query with pagination

page_number = 1
page_size = 10

leaderboard_result_set = sdk.query(
    leaderboard_sql_query, 
    page_size=page_size,
    page_number=page_number)

# for record in leaderboard_result_set.records:
#     print(record)
# x = [row[2] for row in leaderboard_result_set.rows]
# y = [row[1] for row in leaderboard_result_set.rows]
# df = pd.DataFrame(leaderboard_result_set.records)
# chart_data = pd.DataFrame(x, y ,columns=['Holders Value'])
# fig = px.bar(df, x="token_name", y="num_holders", hover_data=df.columns)
# st.bar_chart(chart_data)

# fig = px.bar(df, x="token_name", y="num_holders", hover_data=df.columns)
# st.pyplot(fig)
# fig.show()
# plt.show()

# source = pd.DataFrame(x,y)
df = pd.DataFrame(leaderboard_result_set.records)
# df = df.reset_index().melt(var_name='category', value_name='token_name')

line_chart = alt.Chart(df).mark_bar(interpolate='basis').encode(
    alt.X('token_name', title='Tokens'),
    alt.Y('num_holders', title='Amount'),
    color='token_name'

).properties(
    title='Sales of consumer goods'
)

# line_chart = alt.Chart(df).mark_bar(interpolate='basis').encode(
#     alt.X('chain', title='chain'),
#     alt.Y('total_users', title='Total Users'),
#     color='chain'
# ).properties(
#     title='Sales of consumer goods'
# )
st.image("https://www.forbes.com/advisor/wp-content/uploads/2021/03/ethereum-1.jpeg")
st.altair_chart(line_chart,use_container_width=True)
# option = st.selectbox("Pick one",["Solana","Algo"])
# st.sidebar.write("jhsdkjhfjkdsf")
# st.sidebar.button("click me")


