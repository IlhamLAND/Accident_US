#######
# Here we'll use the mpg.csv dataset to demonstrate
# how multiple inputs can affect the same graph.
######

import dash
import dash_bootstrap_components as dbc
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import plotly.graph_objs as go
import plotly.express as px
import pandas as pd
import numpy as np
import dash_table

import folium
from folium import plugins
import datetime
import matplotlib.pyplot as plt
import seaborn as sns
import geopandas as gpd
import re
import os
import folium1 , folium2, folium3, Time

data = pd.read_csv('C:/Users/Utilisateur/Desktop/CDO/Accident/data_Us_lat.csv' , index_col=0)

data['Start_Time'] = pd.to_datetime(data['Start_Time'] , errors= 'coerce')
df_Time = data[['ID' , 'Start_Time' , 'End_Time']]
df_Time['month_year']= df_Time.Start_Time.dt.to_period('M')
df_M_Y = df_Time.groupby(['month_year']).size().reset_index()
df_M_Y = df_M_Y.rename(columns={0:'nbr'})
df_M_Y['month_year']= df_M_Y['month_year'].dt.to_timestamp()
#################### Par heure 
df_Time['Hour'] = df_Time['Start_Time'].dt.hour
df_Time['Minute'] =df_Time['Start_Time'].dt.minute
hours = [hour for hour, df in df_Time.groupby('Hour')]
#################### Analyse par mois 
df_month = data.groupby(data.Start_Time.dt.month_name()).size().sort_values(ascending=False).reset_index()
df_month = df_month.rename(columns={'Start_Time':'Mois', 0:'nbr_accident'})
#################### Analyse par jour 
df_day = data.groupby(data.Start_Time.dt.day_name()).size().sort_values(ascending=False).reset_index()
df_day = df_day.rename(columns={'Start_Time':'Jour', 0:'nbr_accident'})
#################### Analyse par objet routiers 
bool_cols = [col for col in data.columns if data[col].dtype ==np.dtype('bool')]
booldf = data[bool_cols]
bools = booldf.sum(axis=0)
bools = bools.reset_index()
bools = bools.rename(columns= {'index':'Route_Object', 0: 'NBR'})
################## Analyse conditions métérologiques 
df_weather = data.groupby('Weather_Condition').size().sort_values(ascending= False).reset_index()
df_weather = df_weather.rename(columns={0: 'Nbr_Accident'})
df_weather = df_weather.head(10)
################# Analyse par gravité
df_Severiry = data['Severity'].value_counts().reset_index()
df_Severiry= df_Severiry.rename(columns={'index':'Gravite','Severity': 'Accident'})

###### Les 10  états les plus touchés #############################
State_plot = data.groupby('State').size().sort_values(ascending= False).head(10).sort_values()
State_plot = State_plot.reset_index()
State_plot= State_plot.rename(columns={0:'Nbr_Accident'})



m = folium.Map(location=[40, -96], zoom_start=4.4)
m.save('base_map_us.html')

app = dash.Dash(external_stylesheets=[dbc.themes.CYBORG])
app.layout = dbc.Jumbotron(
    dbc.Container(
    html.Div(
    [

        dbc.Row(
            dbc.Col(
                html.Div(
                    html.H1('Les accidents routiers aux états unis',
                            style={'font-weight':'bold'}),
                    style={
                        'margin-bottom':'25px'
                           }
                    ),
            width={},
            ),
            justify='center',
            style={'background-color':'#41738F'}

        ),

        dbc.Row([
            dbc.Col([
                    html.Div([
                        dcc.Dropdown(
                            id='cas',
                            options=[{'label': 'Nbre accident par état', 'value': 'df_accident_etat'},
                                     {'label': 'Nbre accident par comte', 'value': 'df_accident_comte'},
                                     {'label': 'répartition des accidents/Moy', 'value': 'df_accident_comte_moy'}],
                            value='df_accident_etat',
                            style={'width':'70%'}
                        )
                    ]
                             ),
                html.Div([
                    html.Iframe(id='basemap',
                            srcDoc=open('base_map_us.html').read(),
                            style={'height':600,
                                   'width':800,
                                   'box-shadow':'4px 4px 5px',
                                   'padding':'35px',
                                   'background-color':'white'
                                   }
                            )
                    ],
                         style={'margin-top':'20px'}

                         )
                ],
           width={"size":5, "offset": False}

           ),
            dbc.Col(
                html.Div([
                        dcc.Dropdown(
                            id='case2',
                            options=[{'label': 'climat', 'value': 'df_climat'},
                                     {'label': 'Objet_routier', 'value': 'df_route'}],
                            value='df_route',
                            style={'width':'50%'}
                        ),
                        dcc.Graph(id='graph_condition',config={'displayModeBar': False}, style={'width':600,
                                     'box-shadow':'4px 4px 5px'
                                     })

                    ]
                             )
                
                    
                         ,
                width={"size":5, "offset": 2},
                align='center'
                )

            ],
                align='center',
                justify='center',
                style={'padding-top':'35px',
                       'padding-bottom':'40px'}
                ),

        dbc.Row([ 
            dbc.Col(
                 html.Div([
                        dcc.Dropdown(
                            id='case',
                            options=[{'label': 'Nbre accident par annee', 'value': 'df_accident_annee'},
                                     {'label': 'Nbre accident par mois', 'value': 'df_accident_mois'},
                                     {'label': 'Nbre accident par jour', 'value': 'df_accident_jour'},
                                    {'label': 'Nbre accident par heure', 'value': 'df_accident_heure'}],
                            value='df_accident_annee',
                            style={'width':'70%'}
                        ),
                        dcc.Graph(id='timeseries',config={'displayModeBar': False}, style={'width':800,
                                     'box-shadow':'4px 4px 5px'
                                     })

                    ]
                             )
                
                    
                         ,
                width={"size":5, "offset": False},
                align='start'
                ),
            
            dbc.Col(
                 html.Div([
                        dcc.Dropdown(
                            id='case3',
                            options=[{'label': 'Gravite', 'value': 'df_gravite_total'},
                                     {'label': 'Accident_par_etat', 'value': 'Infected_Etat'}],
                            value='Infected_Etat',
                            style={'width':'50%'}
                        ),
                        dcc.Graph(id='graph_severity',config={'displayModeBar': False}, style={'width':600,
                                     'box-shadow':'4px 4px 5px'
                                     })

                    ]
                             )
                
                    
                         ,
                width={"size":5, "offset": 2},
                align='end'
                )

            ],
                align='center',
                justify='center',
                style={'padding-top':'35px',
                       'padding-bottom':'40px'}
                )


                      ]
    ),
    fluid=True,
    style={'background-color':'#2A4A5C'}

    )
    )


  
@app.callback(
    Output('basemap', 'srcDoc'),
    [Input('cas', 'value')
    ])

def map(caschoisi):
    if caschoisi =='df_accident_etat':
        return open('base_map_accident_etat.html', 'r').read()
    elif  caschoisi =='df_accident_comte':
        return open('base_map_accident_comte.html', 'r').read()
    elif  caschoisi =='df_accident_comte_moy':
        return open('base_map_accident_comte_nbr.html', 'r').read()

@app.callback(
    Output('timeseries', 'figure'),
    [Input('case', 'value')
     ])
def map(caschoisi):
    if caschoisi =='df_accident_annee':

        figure = go.Figure(data=go.Scatter(x=df_M_Y.month_year, y=df_M_Y.nbr, mode='markers' , marker=dict(
        size=12,
        color='firebrick', 
        colorscale='Viridis', 
        showscale=False
         )))
        figure.update_layout(title_text="Evolution des accidents de 2016 à 2019", title_x=0.5 )
        layout =go.Layout(hovermode='closest' ,xaxis={'title':'year_month'},yaxis= {'title':'nbr_accident'})
        return figure
    elif caschoisi =='df_accident_mois':
        figure = px.line(df_month, x="Mois", y="nbr_accident")
        figure.update_traces(mode='markers+lines')
        figure.update_layout(title_text="Evolution des accidents par mois d'année", title_x=0.5 )
        figure.add_annotation(x='December',y=290000,text="December")
        figure.add_annotation(x='January',y=200000,text="January")
        figure.update_annotations(dict( xref="x",yref="y",showarrow=False,arrowhead=7,ax=0,ay=-40 ))
        return figure
    elif caschoisi =='df_accident_jour':
        figure= px.bar(df_day ,x="Jour", y ="nbr_accident" ,color="Jour" , color_discrete_sequence=px.colors.qualitative.Pastel)
        figure.update_layout(title_text="Nombre d'accident par jour de semaine ", title_x=0.5)
        return figure
    elif caschoisi=='df_accident_heure':
        figure =  px.line(df_Time,x= hours, y= df_Time.groupby(['Hour'])['ID'].count())
        figure.update_layout(title_text="Nombre d'accident durant la journée ", title_x=0.5 , xaxis_title="Heure",yaxis_title="Nombre d'accident")
        return figure

@app.callback(
    Output('graph_condition', 'figure'),
    [Input('case2', 'value')
     ])
def map(caschoisi):
    if caschoisi =='df_route':
        figure = px.pie(bools, values='NBR', names='Route_Object',  color_discrete_sequence=px.colors.sequential.Aggrnyl , hole=0.5)
        figure.update_layout(title_text="l'influence des objets routiers", title_x=0.5 )
        return figure
    elif caschoisi =='df_climat':
        figure = px.bar(df_weather, x='Weather_Condition', y='Nbr_Accident' , color="Weather_Condition")
        return figure

@app.callback(
    Output('graph_severity', 'figure'),
    [Input('case3', 'value')
     ])
def map(caschoisi):
    if caschoisi =='df_gravite_total':
        figure = px.pie(df_Severiry, values='Accident', names='Gravite', color_discrete_sequence=px.colors.sequential.RdBu)
        figure.update_layout(title_text="Répartition des accidents par classe de gravité", title_x=0.5)
        return figure
    elif caschoisi =='Infected_Etat':
        figure = px.bar(State_plot, x="Nbr_Accident", y="State", orientation='h' , color="State" )
        figure.update_layout(title_text='Les Top 10 étas les plus touchés', title_x=0.5)
        figure['layout']['yaxis']['autorange'] = "reversed"
        return figure
    
   
if __name__ == '__main__':
    app.run_server(debug=False)



