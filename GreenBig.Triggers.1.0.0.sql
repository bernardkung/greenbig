/*==============================================================*/
/* 					 											*/
/* 		INFO 6210 Data Management and Database Design 			*/
/* 		Group Project 											*/
/* 		Fall 2016      											*/
/* 		            											*/
/* 		Bernard Kung											*/
/* 		Yaqing Wei	 											*/
/* 		Dongqi Li	 											*/
/* 		Behnam Tirandazi										*/
/* 					 											*/
/*==============================================================*/

/*==============================================================*/
/* 		Triggers												*/
/* 		Version 0.9.0											*/
/*==============================================================*/

use GreenBig;
## INSERTS VALUES DELETED FROM METER UPDATE INTO METERVALUE ##
DELIMITER //
DROP TRIGGER IF EXISTS  ConfirmedMeterUpdate //
CREATE TRIGGER ConfirmedMeterUpdate 
AFTER DELETE ON MeterUpdate
FOR EACH ROW
BEGIN

INSERT INTO metervalue(record, MeterID, MeasureTime, MeterValue) VALUES(old.record, old.MeterID, old.MeasureTime, old.MeterValue);

END;
 //
DELIMITER ;


## Adding new weather record
## Checks if new record has an existing weatherstation
## If not, adds a new weatherstation							
DELIMITER //
DROP TRIGGER IF EXISTS updateWeatherstation //
CREATE TRIGGER updateWeatherstation 
BEFORE INSERT ON Weather
FOR EACH ROW
BEGIN
IF NEW.weatherstation NOT IN 									## if we're adding a new weatherstation ##							
	(SELECT ID FROM weatherstation)
																## then add new weatherstation entry ##
THEN
INSERT INTO weatherstation(ID, StationName, StationDesc, CityID)	
SELECT new.weatherstation, 'unknown', 'unknown', '1';

END IF;
END ;
//
DELIMITER ;




## If new weatherstation is added
## Assigns in buildingweather table which buildings are tied to the weatherstation						
DELIMITER //
DROP TRIGGER IF EXISTS insertNewBuildingWeather //
CREATE TRIGGER insertNewBuildingWeather 
AFTER INSERT ON WeatherStation
FOR EACH ROW
BEGIN
																## assign new weatherstation to buildings ##
INSERT INTO buildingweather(buildingID, weatherstationID)		## then add new buildingweather entry ##
	SELECT b.ID, new.ID
    FROM building AS b
	JOIN universitysite AS us
		ON b.siteID = us.ID
	WHERE us.cityID = NEW.CityID;
    
END ;
//
DELIMITER ;



## If a weatherstation entry is updated with a new ID
## Buildingweather updates its foreign key to match it to keep old assignments						
DELIMITER //
DROP TRIGGER IF EXISTS updateBuildingWeather //
CREATE TRIGGER updateBuildingWeather 
AFTER UPDATE ON WeatherStation
FOR EACH ROW
BEGIN

UPDATE buildingweather											## then assign new weatherstation to buildings ##
	SET weatherstationID = NEW.id
    WHERE weatherstationID = OLD.id;
    
END ;
//
DELIMITER ;



