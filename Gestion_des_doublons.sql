################ Table accident ##########################################################
UPDATE accident SET ID =  SUBSTRING(ID, 3, LENGTH(ID));

ALTER TABLE accident  MODIFY ID INTEGER;


########################################### Table accident ####################################
####################################### Détecter les doublons #################################
SELECT COUNT(DISTINCT Source_API , TMC, Severity, Distance , Descriptions, Side) FROM accident;

SELECT  COUNT(*) AS nbr_doublon, ID, Source_API , TMC, Severity, Distance , Descriptions, Side 
FROM     accident  
GROUP BY Source_API , TMC, Severity, Distance , Descriptions, Side
HAVING   COUNT(*) > 1 ;
limit 10; 

####################################### Suppression des doublons ###############################

DELETE accident FROM accident 
LEFT OUTER JOIN (
SELECT MIN(ID) as ID , Source_API , TMC, Severity, Distance , Descriptions, Side
    FROM accident
    GROUP BY Source_API , TMC, Severity, Distance , Descriptions, Side
    ) as t1
    ON accident.ID = t1.ID
 WHERE t1.ID IS NULL ; 



################ Table Localisation_city #########################################################
########################  Triggers ###############################################################
DELIMITER |
CREATE TRIGGER trigger_sup_localisation
    BEFORE DELETE
    ON localisation_city FOR EACH ROW
BEGIN
DECLARE id_lc_new,nbraccident INT DEFAULT 0; 

SELECT  min(Id_LC)  into id_lc_new
FROM     localisation_city  where
Street=OLD.Street and City=OLD.City and
Zipcode=OLD.Zipcode and Start_lat=OLD.Start_lat and 
Start_lng=OLD.Start_lng;

select count(*) into nbraccident from accident where Id_LC= OLD.Id_LC;
if nbraccident <>0 then
update accident set Id_LC =id_lc_new   where Id_LC= OLD.Id_LC;
END IF;

END;

####################################### Détecter les doublons #################################
SELECT COUNT(DISTINCT Street , City, County, Zipcode , Start_lat, Start_lng) FROM localisation_city; 

SELECT  COUNT(*) AS nbr_doublon , Id_LC, Street , City, County, Zipcode , Start_lat, Start_lng  
FROM     localisation_city  
GROUP BY Street , City, County, Zipcode , Start_lat, Start_lng  
HAVING   COUNT(*) > 1 ; 

####################################### Suppression des doublons #################################

 DELETE localisation_city FROM localisation_city
 LEFT OUTER JOIN (
 SELECT MIN(Id_LC) as Id_LC , Street , City , County , Zipcode, Start_lat , Start_lng
 FROM localisation_city
 GROUP BY Street , City , County , Zipcode, Start_lat , Start_lng
  ) as t1
    ON localisation_city.Id_LC = t1.Id_LC
 WHERE t1.Id_LC IS NULL; 




################################### Table route ######################################################
###########################################Triggers ##################################################

DELIMITER |
CREATE TRIGGER trigger_sup_route
    BEFORE DELETE
    ON route FOR EACH ROW
BEGIN
DECLARE Id_Route_new,nbraccident INT DEFAULT 0; 

SELECT  min(Id_Route)  into Id_Route_new
FROM     route  where
Amenity=OLD.Amenity and Bump=OLD.Bump and Crossing= OLD.Crossing and Give_Way=OLD.Give_Way and Junction=OLD.Junction
No_Exit=OLD.No_Exit and Railway=OLD.Railway and Roundabout= OLD.Roundabout and Station= OLD.Station and Stop= OLD.Stop
Traffic_Calming=OLD.Traffic_Calming and  Traffic_Signal= OLD.Traffic_Signal and  Turning_Loop= OLD.Turning_Loop;

select count(*) into nbraccident from accident where Id_Route= OLD.Id_Route;
if nbraccident <>0 then
update accident set Id_Route =Id_Route_new   where Id_Route= OLD.Id_Route;
END IF;

END;

####################################### Détecter les doublons #################################

SELECT COUNT(DISTINCT Amenity, Bump , Crossing, Give_Way, Junction , No_Exit, Railway, Roundabout , Station , Stop , Traffic_Calming, Traffic_Signal , Turning_Loop) FROM route ;

SELECT  COUNT(*) AS nbr_doublon ,Id_Route ,Amenity, Bump , Crossing, Give_Way, Junction , No_Exit, Railway, Roundabout , Station , Stop , Traffic_Calming, Traffic_Signal , Turning_Loop
FROM     route  
GROUP BY Amenity, Bump , Crossing, Give_Way, Junction , No_Exit, Railway, Roundabout , Station , Stop , Traffic_Calming, Traffic_Signal , Turning_Loop
HAVING   COUNT(*) > 1; 


####################################### Suppression des doublons #################################

 DELETE route FROM route
 LEFT OUTER JOIN (
 SELECT MIN(Id_Route) as Id_Route ,Amenity, Bump , Crossing, Give_Way, Junction , No_Exit, Railway, Roundabout , Station , Stop , Traffic_Calming, Traffic_Signal , Turning_Loop
 FROM route
 GROUP BY Amenity, Bump , Crossing, Give_Way, Junction , No_Exit, Railway, Roundabout , Station , Stop , Traffic_Calming, Traffic_Signal , Turning_Loop
  ) as t1
    ON route.Id_Route = t1.Id_Route
 WHERE t1.Id_Route IS NULL; 



################################### Table meteo ######################################################
###########################################Triggers ##################################################


DELIMITER |
CREATE TRIGGER trigger_sup_meteo
    BEFORE DELETE
    ON donnees_meteorologiques FOR EACH ROW
BEGIN
DECLARE id_DM_new,nbraccident,nbrstation INT DEFAULT 0; 
SELECT  min(Id_DM)  into id_DM_new
FROM     donnees_meteorologiques  where
Temperature=OLD.Temperature and Humidity=OLD.Humidity and
Pressure=OLD.Pressure and Visibility=OLD.Visibility and 
Wind_Direction=OLD.Wind_Direction and  Wind_speed = OLD.Wind_speed and Weather_condition=OLD.Weather_condition ;
select count(*) into nbraccident  from accident where Id_DM= OLD.Id_DM;
if nbraccident <>0  then
update accident   set Id_DM =id_DM_new  where id_DM= OLD.id_DM;
END IF;

select count(*) into nbrstation from prise_parametre where Id_DM= OLD.Id_DM;
if nbrstation <>0 then
update prise_parametre set Id_DM =id_DM_new   where id_DM= OLD.id_DM;
END IF;
END;

####################################### Détecter les doublons #################################
SELECT COUNT(DISTINCT Temperature, Humidity, Pressure, Visibility, Wind_Direction , Wind_speed, Weather_condition) FROM  donnees_meteorologiques;

SELECT  COUNT(*) AS nbr_doublon ,Id_DM ,Temperature, Humidity, Pressure, Visibility, Wind_Direction , Wind_speed, Weather_condition
FROM     donnees_meteorologiques  
GROUP BY Temperature, Humidity, Pressure, Visibility, Wind_Direction , Wind_speed, Weather_condition
HAVING   COUNT(*) > 1; 


 ####################################### Suppression des doublons ###############################


 DELETE donnees_meteorologiques FROM donnees_meteorologiques
 LEFT OUTER JOIN (
 SELECT MIN(Id_DM) as Id_DM ,Temperature, Humidity, Pressure, Visibility, Wind_Direction , Wind_speed, Weather_condition
 FROM donnees_meteorologiques
 GROUP BY Temperature, Humidity, Pressure, Visibility, Wind_Direction , Wind_speed, Weather_condition
  ) as t1
    ON donnees_meteorologiques.Id_DM = t1.Id_DM
 WHERE t1.Id_DM IS NULL; 



################################### Table Station ####################################################
###########################################Triggers ##################################################

DELIMITER |
CREATE TRIGGER trigger_sup_station
    BEFORE DELETE
    ON station_meteorologique FOR EACH ROW
BEGIN
DECLARE id_SM_new,nbrmeteo INT DEFAULT 0; 

SELECT  min(Id_SM)  into id_SM_new
FROM     station_meteorologique  where
airport_code=OLD.airport_code and Weather_Timestamp=OLD.Weather_Timestamp ;

select count(*) into nbrmeteo from prise_parametre where Id_SM= OLD.Id_SM;
if nbrmeteo <>0 then
update prise_parametre  set Id_SM =id_SM_new   where Id_SM= OLD.Id_SM;
END IF;
END;

####################################### Détecter les doublons #################################


SELECT COUNT(DISTINCT airport_code, Weather_Timestamp) FROM  station_meteorologique;

 ####################################### Suppression des doublons ###############################
 DELETE station_meteorologique FROM station_meteorologique
 LEFT OUTER JOIN (
 SELECT MIN(Id_SM) as Id_SM ,airport_code, Weather_Timestamp
 FROM station_meteorologique
 GROUP BY airport_code, Weather_Timestamp
  ) as t1
    ON station_meteorologique.Id_SM = t1.Id_SM
 WHERE t1.Id_SM IS NULL; 




################################### Table Temps ####################################################
###########################################Triggers ##################################################

DELIMITER |
CREATE TRIGGER trigger_sup_temps
    BEFORE DELETE
    ON donnees_temporelles FOR EACH ROW
BEGIN
DECLARE id_DT_new,nbraccident INT DEFAULT 0; 

SELECT  min(Id_DT)  into id_DT_new
FROM     donnees_temporelles  where
Start_Time=OLD.Start_Time and End_Time=OLD.End_Time and
Timezone=OLD.Timezone and Sunrise_Sunset=OLD.Sunrise_Sunset ;

select count(*) into nbraccident from accident where Id_DT= OLD.Id_DT;
if nbraccident <>0 then
update accident set Id_DT =id_DT_new   where Id_DT= OLD.Id_DT;
END IF;
END;

####################################### Détecter les doublons #################################

SELECT COUNT(DISTINCT Start_Time, End_Time, Timezone, Sunrise_Sunset ) FROM  donnees_temporelles;


 ####################################### Suppression des doublons ###############################

 DELETE donnees_temporelles FROM donnees_temporelles
 LEFT OUTER JOIN (
 SELECT MIN(Id_DT) as Id_DT ,Start_Time, End_Time, Timezone, Sunrise_Sunset
 FROM donnees_temporelles
 GROUP BY Start_Time, End_Time, Timezone, Sunrise_Sunset
  ) as t1
    ON donnees_temporelles.Id_DT = t1.Id_DT
 WHERE t1.Id_DT IS NULL; 



