#############Importation 

import pandas as pd 
import urllib.request
import urllib.error
import urllib.parse 
import json
import datetime
from datetime import datetime
import json 
from sqlalchemy import create_engine
import sqlalchemy
import pymysql 
import csv
from datetime import date
from pandas.io.json import json_normalize


# Chercher la date courante formaté

today = date.today().strftime('%m_%d_%Y')

# Je me suis inscrite sur Mapquest Développeur qui permet de récupérer les données à partir de l'API en utilisant API_KEY

APP_KEY = 'Fmjtd%7Cluu82luanl%2C72%3Do5-948x04'
URL = 'http://www.mapquestapi.com/traffic/v2/incidents?key={}&boundingBox=39.95,-105.25,39.52,-104.71'.format(APP_KEY)

# Chercher les données
#Prend une URL et retourne un objet Python représentant le JSON analysé 

def get_result(url:str)->'json':

    response = None
    try:
        response = urllib.request.urlopen(url)
        # Converts response to JSON format 
        json_text = response.read().decode(encoding = 'utf-8')
        # Converts into Python object 
        return json.loads(json_text)
    except urllib.error.HTTPError as e:
        print('Failed to download contents of URL')
        print('Status code: {}'.format(e.code))
        print()
    finally:
        if response != None:
            response.close()

Json_result = get_result(URL)

# Enregistrement du fichier Json avec la date courante
with open('C:/Users/Utilisateur/Desktop/CDO/Automatisation/outputfile_{}.json'.format(today), 'w') as fp:
	json.dump(Json_result, fp)
# Transformer le json en csv

with open('C:/Users/Utilisateur/Desktop/CDO/Automatisation/outputfile_{}.json'.format(today)) as data_file:
    data = json.load(data_file) 

df = json_normalize(data['incidents'])


df= df[['id','type','severity','eventCode','lat','lng','startTime','endTime','impacting','shortDesc','parameterizedDescription.roadName']]
df= df.rename(columns={'shortDesc':'description', 'parameterizedDescription.roadName':'roadName'})


# Etablir la connexion entre JupiterNotebook et Mysql par Pysmysql

connection = pymysql.connect(host='localhost',
                     user='root', 
                     password='root',
                     db='accident_BDD_API')

cursor = connection.cursor()

# Injection des données sur la table Mysql. 

for d in df.itertuples():
    cursor.execute("select count(*) from accident_api where id="+d.id)  
    result = cursor.fetchone()[0]
    if result==0:
        sqlrequet= "Insert into accident_api values(%s, %s, %s, %s, %s,%s, %s, %s, %s, %s,%s)"
        cursor.execute(sqlrequet,(d.id,d.type,d.severity,d.eventCode,d.lat,d.lng,d.startTime,d.endTime,d.impacting, d.description, d.roadName))
        connection.commit()
connection.close()   
print("It's done")



