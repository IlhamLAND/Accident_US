Use accident_us ;
##### Etat qui le plus grand nombre d'accident 

select count(ID)as nbr , e.State_code ,  e.name from accident as a 
inner join localisation_city as lc on a.Id_LC=lc.Id_LC
inner join comte as c on c.County = lc.County
inner join etat as e on e.State_code=c.State_code
group by State_code 
order by nbr desc  
limit 10  ; 

##### County qui le plus grand nombre d'accident 

select count(ID)as nbr , c.County , e.State_code, e.name  from accident as a 
inner join localisation_city as lc on a.Id_LC=lc.Id_LC
inner join comte as c on c.County = lc.County
inner join etat as e on e.State_code= c.State_code
group by County 
order by nbr desc  
limit 10  ; 

##### City qui a le plus grand nombre d'accident 

select count(a.ID) as nbr , lc.City , lc.County 
from accident as a 
inner join localisation_city as lc on a.Id_LC= lc.Id_LC
group by City
order by nbr desc 
limit 10 ;

###### Le nombre d'accidents par Gravité 

select count(ID) as nbr , Severity from accident 
group by Severity
order by nbr desc
limit 10; 

##### La distance occupée par les accidents 

select ID , Distance from accident
order by Distance desc limit 10; 

##### Nombre d'accident par Timezone
 
select count(ID) as nbr , Timezone from accident as a 
inner join donnees_temporelles as dt on a.Id_DT= dt.Id_DT
group by Timezone 
order  by nbr desc ;

########## La durée occupée pour chaque accident ########

select ID , County, City,   End_time, Start_Time, 
TIMEDIFF(End_time , Start_Time) as duree from accident as a 
inner join donnees_temporelles as dt on dt.Id_DT= a.Id_DT
inner join localisation_city as lc on lc.Id_LC= a.Id_LC ; 


##### nbr d'accident par nuit/Journéé

select count(ID) as nbr , Sunrise_Sunset from accident as a 
inner join donnees_temporelles as dt on dt.Id_DT=a.Id_DT
group by Sunrise_Sunset; 

#### nbr accident selon la direction des vents 

select  Wind_Direction , count(ID) as nbr  from accident as a 
inner join donnees_meteorologiques as dm on a.Id_DM= dm.Id_DM
group by Wind_Direction 
order by nbr desc
limit 10;

####nbr accident selon weather conditions 

select count(ID) as nbr , Sunrise_Sunset from accident as a 
inner join donnees_temporelles as dt on dt.Id_DT=a.Id_DT
group by Sunrise_Sunset; 

#### nbr accident selon la direction des vents 

select  Wind_Direction , count(ID) as nbr  from accident as a 
inner join donnees_meteorologiques as dm on a.Id_DM= dm.Id_DM
group by Wind_Direction 
order by nbr desc
limit 10;

#### nbr accident selon la direction des vents 


select  Weather_condition , count(ID) as nbr  from accident as a 
inner join donnees_meteorologiques as dm on a.Id_DM= dm.Id_DM
group by Weather_condition 
order by nbr desc
limit 10;





Explain select count(ID)as nbr , e.State_code ,  e.name from accident as a 
inner join localisation_city as lc on a.Id_LC=lc.Id_LC
inner join comte as c on c.County = lc.County
inner join etat as e on e.State_code=c.State_code
group by State_code 
order by nbr desc  
limit 10  ; 





 