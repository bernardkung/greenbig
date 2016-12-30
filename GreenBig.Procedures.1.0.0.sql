/*==============================================================*/
/* 					 											*/
/* 		INFO 6210 Data Management and Database Design 			*/
/* 		Group Project 											*/
/* 		Fall 2016      											*/
/* 					 											*/
/* 		Bernard Kung											*/
/* 		Yaqing Wei	 											*/
/* 		Dongqi Li	 											*/
/* 		Behnam Tirandazi										*/
/* 					 											*/
/*==============================================================*/

/*==============================================================*/
/* 		Procedures												*/
/* 		Version 1.0.0											*/
/*==============================================================*/


use GreenBig;
SET SQL_SAFE_UPDATES = 0;


## BUILDING WEATHER between TARGET DATES ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_BuildingWeather //
CREATE PROCEDURE sp_BuildingWeather(in buildID VARCHAR(6), IN startdate CHAR(20), IN enddate CHAR(20))		## Enter timedates AS char, convert to datetime for explicit timedates ##
BEGIN																										 

IF startdate LIKE 'min%' THEN SET startdate = CONVERT('000000.00000', DECIMAL(11,5)); 			## if they enter min, set startdate as a minimum datenum
ELSE SET startdate = CONVERT(datenum(startdate), DECIMAL(11,5));								## otherwise pass it through
END IF;

IF startdate = '0000-00-00 00:00:00' THEN SET startdate = '0000-01-01 00:00:00'; END IF;		## if they have some familiarity with datetime, they may logically guess all 0s as acceptable. Which it isn't. This handles that possiblity.

IF enddate LIKE 'max%' THEN SET enddate =  CONVERT('744382.00000', DECIMAL(11,5)); 				## if they enter max, set enddate as max datenum
ELSE SET enddate = CONVERT(datenum(enddate), DECIMAL(11,5));									## otherwise convert datetime into datenum
END IF;


SELECT buildID AS buildingID, v_w.* 
FROM v_weather AS v_w
	JOIN Weatherstation AS ws
		ON v_w.weatherstation = ws.ID
    JOIN universitysite AS us
		ON ws.cityID = us.cityID
    JOIN building AS b
		ON us.ID = b.siteID 	
	WHERE b.ID = buildID	## VARIABLE HERE 
	AND v_w.measuretime BETWEEN startdate AND enddate											## startdate and enddate are datenum form ##

	ORDER BY b.ID ASC, v_w.measuretime ASC;

END //
DELIMITER ;


## SITE WEATHER between TARGET DATES ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_SiteWeather //
CREATE PROCEDURE sp_SiteWeather(in siteID INT, IN startdate CHAR(20), IN enddate CHAR(20))		## Enter timedates AS char, convert to datetime for explicit timedates ##
BEGIN																								## otherwise convert to minimum timedate 


IF startdate LIKE 'min%' THEN SET startdate = CONVERT('000000.00000', DECIMAL(11,5)); 		## If user enters min or minimum, then return a minimum datenumber ##	
ELSE SET startdate = CONVERT(datenum(startdate), DECIMAL(11,5));							## Otherwise, convert startdate into datenumber ##
END IF;

IF startdate = '0000-00-00 00:00:00' THEN SET startdate = '0000-01-01 00:00:00'; 
END IF;

IF enddate LIKE 'max%' THEN SET enddate =  CONVERT('744382.00000', DECIMAL(11,5)); 			## if they enter max, set enddate as max datenum ##
ELSE SET enddate = CONVERT(datenum(enddate), DECIMAL(11,5));
END IF;

SELECT siteID, v_w.* 	## too large, pull site weather instead
FROM v_weather AS v_w
    JOIN Weatherstation AS ws
		ON v_w.weatherstation = ws.ID			## select siteIDs for all buildings ##
    RIGHT JOIN universitysite AS us
		ON ws.cityID = us.cityID
	WHERE us.ID = siteID
   AND v_w.measuretime BETWEEN startdate AND enddate			## startdate and enddate are datenum form ##
##	AND measuretime BETWEEN '2011-10-03 01:00:03' AND '2014-04-b27 03:00:00'			## startdate and enddate are datenum form ##    
## call sp_buildingweather('all','2011-10-03 01:00:03','2014-04-27 03:00:00');

	ORDER BY us.ID ASC, v_w.measuretime ASC;

END //
DELIMITER ;


## IMPORT METER UPDATES INTO METER VALUE ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_ConfirmUpdate //
CREATE PROCEDURE sp_ConfirmUpdate(IN answer VARCHAR(3))
BEGIN
IF answer LIKE 'y%' THEN

	DELETE FROM meterupdate;

END IF
;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_CancelUpdate //
CREATE PROCEDURE sp_CancelUpdate()
BEGIN


TRUNCATE TABLE meterupdate;

END //
DELIMITER ;


## CHECK ALL UPDATES AFTER TARGET DATE ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_CheckMeterUpdate //
CREATE PROCEDURE sp_CheckMeterUpdate(IN targetdate date)
BEGIN

SELECT * FROM MeterUpdate AS mu
WHERE date(mu.wh_LoadDate)  >= targetdate	## ENTER TARGET DATE FOR MULTIPLE QUEUED UPDATES ##
ORDER BY mu.wh_LoadDate
;
END //
DELIMITER ;



## RESOURCE COUNT for each BUILDING per METER in TARGET DATES ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_BuildingMeterSum //
CREATE PROCEDURE sp_BuildingMeterSum(in buildID VARCHAR(6), IN startdate CHAR(20), IN enddate CHAR(20))
BEGIN

IF buildID = '' THEN SET buildID = 'all'; END IF;

IF startdate LIKE 'min%' THEN SET startdate = CONVERT('000000.00000', DECIMAL(11,5)); 
ELSE SET startdate = CONVERT(datenum(startdate), DECIMAL(11,5));
END IF;

IF enddate LIKE 'max%' THEN SET enddate =  CONVERT('744382.00000', DECIMAL(11,5)); 			## if they enter max, set enddate as max datenum ##
ELSE SET enddate = CONVERT(datenum(enddate), DECIMAL(11,5));
END IF;

IF buildID = 'all' THEN		## FOR ALL METERS IN A BUILDING
SELECT SUM(mv.metervalue) AS ResourceSum, m.ID AS meterID, b.ID AS buildingID, m.resourceID
FROM metervalue AS mv 
	JOIN meter AS m 
		ON mv.meterID = m.ID
	RIGHT JOIN building AS b
		ON m.buildingID = b.ID
	WHERE mv.measuretime BETWEEN startdate AND enddate
GROUP BY mv.meterID, m.resourceID
ORDER BY mv.meterID ASC
;

ELSE		## FOR INDIVIDUAL BUILDINGS ##
SELECT SUM(mv.metervalue) AS ResourceSum, m.ID AS meterID, b.ID AS buildingID, m.resourceID
FROM metervalue AS mv 
	JOIN meter AS m 
		ON mv.meterID = m.ID
	RIGHT JOIN building AS b
		ON m.buildingID = b.ID
	WHERE b.ID = buildID ## VARIABLE HERE ##
	AND mv.measuretime BETWEEN startdate AND enddate
GROUP BY mv.meterID, m.resourceID
ORDER BY mv.meterID ASC
;

END IF;


END //
DELIMITER ;

## WORKING ##
## RESOURCE COUNT for each BUILDING ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_TotalBuildingMeterSum //
CREATE PROCEDURE sp_TotalBuildingMeterSum(in buildID VARCHAR(6))
BEGIN
SELECT SUM(mv.metervalue), b.ID
FROM metervalue AS mv 
	LEFT JOIN meter AS m 
		ON mv.meterID = m.ID
	RIGHT JOIN building AS b
		ON m.buildingID = b.ID
	WHERE b.ID = buildID ## VARIABLE HERE ##
GROUP BY b.ID, mv.meterID
;
END //
DELIMITER ;


## RETURN BUILDING EUI ## ##ENERGY PER SQF##
DELIMITER \\
drop procedure IF EXISTS sp_EUI \\
CREATE PROCEDURE sp_EUI(IN targetbuilding VARCHAR(6),  IN startdate CHAR(20), IN enddate CHAR(20))
BEGIN

DECLARE building_SQF INT;				## variable holds our buildingSQF

IF targetbuilding = '' THEN SET targetbuilding = 'all'; END IF;

IF startdate LIKE 'min%' THEN SET startdate = CONVERT('000000.00000', DECIMAL(11,5)); 
ELSE SET startdate = CONVERT(datenum(startdate), DECIMAL(11,5));
END IF;

IF enddate LIKE 'max%' THEN SET enddate =  CONVERT('744382.00000', DECIMAL(11,5)); 			## if they enter max, set enddate as max datenum ##
ELSE SET enddate = CONVERT(datenum(enddate), DECIMAL(11,5));
END IF;

IF targetbuilding = 'all' THEN		## FOR ALL METERS IN ALL BUILDINGS

## BUILDING SQF ##
SELECT sum(bf.structural_sqf)+ sum(rd.room_sqf)
from buildingfloor AS bf
LEFT join roomdesc AS rd
ON bf.ID = rd.buildingfloorID
INTO building_SQF					## inserting into variables allows us to do two select queries as one procedure
;

SELECT b.ID AS buildingID, SUM(mv.metervalue)/building_SQF AS EUI, mv.meterID, r.resourcename AS Resource			## variable gets used here, and we get a single output with two select queries.
FROM metervalue AS mv 
	JOIN meter AS m 
		ON mv.meterID = m.ID
	RIGHT JOIN building AS b
		ON m.buildingID = b.ID
	LEFT JOIN resource AS r
		ON m.resourceID = r.ID
##    WHERE m.ResourceID = ## targetresource ##

	WHERE mv.measuretime BETWEEN startdate AND enddate
    GROUP BY mv.meterID;
    
ELSE 

## BUILDING SQF ##
SELECT sum(bf.structural_sqf)+ sum(rd.room_sqf)
from buildingfloor AS bf
LEFT join roomdesc AS rd
ON bf.ID = rd.buildingfloorID
WHERE bf.buildingID = targetbuilding ##targetbuilding
INTO building_SQF
;

SELECT b.ID AS buildingID, SUM(mv.metervalue)/building_SQF AS EUI, mv.meterID, r.resourcename AS Resource
FROM metervalue AS mv 
	JOIN meter AS m 
		ON mv.meterID = m.ID
	RIGHT JOIN building AS b
		ON m.buildingID = b.ID
	LEFT JOIN resource AS r
		ON m.resourceID = r.ID
	WHERE b.ID = targetbuilding ## targetbuilding ##
    AND  mv.measuretime BETWEEN startdate AND enddate
##    WHERE m.ResourceID = ## targetresource ##
    GROUP BY mv.meterID;

END IF;

END \\
DELIMITER ;




## Buildings with Meter Readings ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_activemeters //
CREATE PROCEDURE sp_activemeters()
BEGIN
SELECT DISTINCT(buildingID) FROM meter
RIGHT JOIN metervalue
ON meter.ID=metervalue.meterID
WHERE metervalue.metervalue >0;
END //
DELIMITER ;



## RESOURCE COUNT for each UNIVERSITY SITE ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_SiteMeterSum //
CREATE PROCEDURE sp_SiteMeterSum(IN siteID INT)
BEGIN
## RESOURCE COUNT for each UNIVERSITY CAMPUS ##
SELECT SUM(mv.metervalue)
FROM metervalue as mv
	LEFT JOIN meter AS m
		on mv.meterID = m.ID
	LEFT JOIN building as b
		on m.buildingID = b.ID
	WHERE b.siteID IN (
		SELECT us.ID 
			FROM universitysite AS us 
            WHERE us.ID IN (siteID) ## VARIABLE HERE ##
		)
;
END //
DELIMITER ;

## RESOURCE COUNT for each UNIVERSITY ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_UniversityMeterSum //
CREATE PROCEDURE sp_UniversityMeterSum(IN queryID int)
BEGIN
SELECT SUM(mv.metervalue)
FROM metervalue AS mv
WHERE mv.meterID IN (
	SELECT m.ID
    FROM meter AS m
    WHERE m.buildingID IN (
		SELECT b.ID
        FROM building AS b
        WHERE b.universityID = queryID ## VARIABLE HERE ##
	)
)
;
END //
DELIMITER ;

DELIMITER \\
drop procedure if exists sp_predict \\
create procedure sp_predict(in targetmonth INT)
BEGIN
select (dailychillwater/0.22099528734317145)-1, (dailysteam/0.0005635057515218605)-1, (dailyelectricty/0.23800501765998072)-1 
FROM historicalbenchmark WHERE monthID = targetmonth;
END
\\
DELIMITER ;

/*

## For when equipment is tied to room, instead of building.

## EQUIPMENT LIST for each ROOM ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_RoomEquipment //
CREATE PROCEDURE sp_RoomEquipment(in targetRoom VARCHAR(10))
BEGIN
SELECT el.EqptTagName, e.EquipmentName
FROM EquipmentList AS el
	LEFT JOIN equipment AS e
    ON el.equipmentID = e.ID
    WHERE el.RoomID = targetRoom ## VARIABLE HERE ##
ORDER BY e.equipmentName
;
END //
DELIMITER ;

## EQUIPMENT COUNT for each ROOM ##
DELIMITER //
DROP PROCEDURE IF EXISTS sp_CountRoomTypeEquipment //
CREATE PROCEDURE sp_CountRoomTypeEquipment(in targetRMU VARCHAR(2))
BEGIN
SELECT COUNT(el.EqptTagName), e.EquipmentName, rmu.MajorUsageShort, rt.RoomType
FROM EquipmentList as el
	LEFT JOIN equipment AS e
    ON el.equipmentID = e.ID
    WHERE el.roomID IN (
    SELECT  rd.ID
        FROM RoomDesc AS rd
			JOIN RoomMajorUsage AS rmu
				ON rd.UsageID = rmu.ID
			JOIN RoomType AS rt
				ON rd.ID = rt.RoomMajorUsageID
		WHERE rmu.ID = targetRMU ## VARIABLE HERE ##
        )
	ORDER BY rmu.MajorUsageShort ASC
;
END //
DELIMITER;
*/