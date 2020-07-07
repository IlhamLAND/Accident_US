#################### Création de la base de données accident_US ###################

CREATE DATABASE IF NOT EXISTS accident_US; 
use accident_US ;


#################### Création de la table  State ####################################################
create table Etat 
( 
State_code varchar(2) not null primary key ,  
name varchar(20),
Country varchar(2));


#################### Création de la table  Comte ####################################################

create table Comte 
( 
County varchar(20) not null primary key ,  
County_fips int , 
State_code varchar(2));


#################### Création de la table  Localisation  ###############################################
create table Localisation_city  
( 
Id_LC int not null primary key ,  
Street varchar(60), 
City varchar(30), 
County varchar(22), 
Zipcode varchar(10), 
Start_lat float, 
Start_lng float );



####################### Création de la table données_Temporelles ########################################

create table Donnees_Temporelles 
( 
Id_DT int not null primary key ,
Start_Time datetime, 
End_time datetime,
Timezone varchar(12),
Sunrise_Sunset varchar(5) );



######################## Création de la table Route #######################################################

create table Route 
( 
Id_Route  int not null primary key , 
Amenity boolean , 
Bump boolean,
Crossing boolean,
Give_Way boolean, 
Junction boolean, 
No_Exit boolean, 
Railway boolean , 
Roundabout boolean, 
Station boolean, 
Stop boolean, 
Traffic_Calming boolean , 
Traffic_Signal boolean, 
Turning_Loop boolean);



######################## Création de la table Donnees_Météorologiques #######################################

create table Donnees_Meteorologiques 
( 
Id_DM int not null primary key ,  
Temperature float, 
Humidity float,
Pressure float,
Visibility float, 
Wind_Direction varchar(8) , 
Wind_speed float , 
Weather_condition varchar(35));



######################## Création de la table Station_Météorologiques #######################################

create table Station_Meteorologique 
( 
Id_SM int not null primary key ,  
airport_code varchar(4), 
Weather_Timestamp datetime );



#################### Création de la table Prise parametre ##################################################

Create table prise_parametre
(
Id_SM int not null , 
Id_DM int not null , 
PRIMARY KEY(Id_SM, Id_DM)
); 


######################### Création de la table accident #################################################

create table accident 
( 
ID varchar(10) not null primary key ,  
Source_API varchar(20), 
TMC float,
Severity int,
Distance float, 
Descriptions varchar(500), 
Side varchar(1) ,
Id_LC int not null,
Id_DM int not null ,
Id_DT int not null,
Id_Route int not null 
);





#################### Foreign key  : table  Comte ####################################################
Alter table Comte 
ADD CONSTRAINT fk_comte_state
foreign  key (State_code) references Etat(State_code) ;


############################### Foreign key : Table Localisation_city ###############################
Alter table Localisation_city 
ADD CONSTRAINT fk_localisation_comte
foreign  key (County) references comte(County) ;


#################### Ajout des clés étrangères dans la table prise_parametre ################################

Alter table prise_parametre 
ADD CONSTRAINT fk_prise_station
foreign  key (Id_SM) references Station_Meteorologique(Id_SM) ; 



Alter table prise_parametre 
ADD CONSTRAINT fk_prise_data
foreign  key (Id_DM) references Donnees_Meteorologiques(Id_DM) ; 




############### Ajout des contraintes   Dans la table Accident ################################################
########################################Table Localisation ####################################################

Alter table accident 
ADD CONSTRAINT fk_accident_localisation
foreign  key (Id_LC) references Localisation_city(Id_LC)  ; 



########################################Table Donnees Meteorologiques ########################################


Alter table accident 
ADD CONSTRAINT fk_accident_Meteo
foreign  key (Id_DM) references Donnees_Meteorologiques(Id_DM) ; 


########################################Table Donnees Temporelles ###########################################


Alter table accident 
ADD CONSTRAINT fk_accident_Temps
foreign  key (Id_DT) references Donnees_Temporelles(Id_DT) ; 



########################################Table Route #########################################################

Alter table accident 
ADD CONSTRAINT fk_accident_Route
foreign  key (Id_Route) references Route(Id_Route) ;




#################### Chargement de la table State #######################################################


LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/Etat_US.csv'
INTO TABLE Etat
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#################### Chargement de la table Comte #######################################################


LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/comte.csv'
INTO TABLE comte
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


#################### Chargement de la localisation  #####################################################


LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/localisation.csv'
#'C:/Users/Utilisateur/Desktop/CDO/localisation.csv'
INTO TABLE Localisation_city
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


####################### Chargement de la table Données_Temporelles ########################################

LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/donnees_temporelles.csv' 
INTO TABLE Donnees_Temporelles
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

####################### Chargement de la table Route ##########################################################

LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/Route.csv'
INTO TABLE Route
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


####################### Chargement de la table Donnees_Meteorologiques #######################################

LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/Meteo.csv'
INTO TABLE Donnees_Meteorologiques
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

####################### Chargement de la table Station_Meteorologiques ######################################

LOAD DATA LOCAL INFILE

'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/station_Meteo.csv'
INTO TABLE Station_Meteorologique
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#################### Chargement de la table prise_parametre################################################

LOAD DATA LOCAL INFILE

'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/Prise_P.csv'
INTO TABLE prise_parametre
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

####################### Chargement de la table Accident #################################################

LOAD DATA LOCAL INFILE
'C:/Users/Utilisateur/Desktop/CDO/Table US_Accident/accident.csv'
INTO TABLE accident
Fields TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


