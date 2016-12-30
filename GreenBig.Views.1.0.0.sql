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
/* 		User Views												*/
/* 		Version 1.0.0											*/
/*==============================================================*/

use GreenBig;

## Lists  a full directory of all rooms in all buildings, and associated building and room information.

DROP VIEW IF EXISTS v_RoomDirectory;
CREATE VIEW v_RoomDirectory AS

	SELECT 
	b.*, 
	bf.ID AS FloorID, 
    bf.Floornumber, 
    bf.Structural_SQF, 
    rd.ID AS RoomID, 
    rd.Room_SQF, 
    rd.RoomUsageID AS RoomTypeID, 
    rd.DeptID, rt.RoomType, 
    rt.RoomMajorUsageID, 
    rmu.MajorUsage, 
    rmu.MajorUsageShort, 
    rmu.Assignable
    
	FROM Building AS b
    LEFT JOIN buildingfloor AS bf
		ON b.ID = bf.buildingID
	JOIN RoomDesc AS rd
		ON bf.ID = rd.buildingfloorID
	LEFT JOIN RoomType AS rt
		ON rd.RoomUsageID = rt.ID
	LEFT JOIN RoomMajorUsage AS rmu
		ON rt.RoomMajorUsageID = rmu.ID
	;
    
    
##    Lists the number of rooms grouped by major usage in a building.
DROP VIEW IF EXISTS v_BuildingRMUCounts;
CREATE VIEW v_BuildingRMUCounts AS
select b.ID AS bID, rmu.ID AS rmuID , count(rd.ID) AS RMUCount
FROM Building AS b
	LEFT JOIN buildingfloor AS bf
		ON b.ID = bf.buildingID
	LEFT JOIN RoomDesc AS rd
		ON bf.ID = rd.buildingFloorID
	LEFT JOIN RoomType AS rt
		ON rd.roomusageID = rt.ID
	LEFT JOIN RoomMajorUsage AS rmu
		ON rt.roommajorusageID = rmu.ID
	GROUP BY b.ID, rmu.ID
    ;

## IRRELEVENT FUNCTIONALITY AFTER EQUIPMENT TIED TO BUILDINGS INSTEAD OF ROOM ##
/* 
DROP VIEW IF EXISTS v_BuildingEquipment;
CREATE VIEW v_BuildingEquipment AS
SELECT b.ID, b.buildingName, el.EqptTagName, e.ID AS eqptID, e.EquipmentName, et.ID AS typeID, et.eqpttypename AS typeName, est.ID AS subtypeID, est.EqptSubType AS subtypeName
	FROM building AS b
    LEFT JOIN buildingfloor AS bf
		ON b.ID = bf.buildingID
	LEFT JOIN roomdesc AS rd
		ON bf.ID = rd.buildingfloorID
	LEFT JOIN EquipmentList AS el
		ON rd.ID = el.RoomID
	LEFT JOIN equipment AS e
		ON el.EquipmentID = e.ID
	LEFT JOIN equipmenttype AS et
		ON e.equipmenttypeID = et.ID
    LEFT JOIN equipmentsubtype AS est
		ON et.equipmentsubtypeID = est.ID
	;
*/

## Lists all meters attached to a building

DROP VIEW IF EXISTS v_BuildingMeters;
CREATE VIEW v_BuildingMeters AS
	SELECT 
		b.ID, 
        b.buildingName, 
        m.ID AS meterID, 
        m.metertagname, 
        m.ResourceID, 
        r.Resourcename
	
    FROM Building AS b
	LEFT JOIN Meter AS m
		ON b.ID = m.BuildingID
	JOIN Resource AS r
		ON m.resourceID = r.ID
    ;



## AVG METER SUMS GROUPED BY HOUR AND METER AND BUILDING##
DROP VIEW IF EXISTS v_Meters;
CREATE VIEW v_Meters AS

	SELECT 	
		b.ID, 
		mv.MeterID, 
		1+FLOOR(mv.measuretime*24)/24 AS measuretime,		## Returns the hour over which we average meter values
		FLOOR(mv.measuretime*24) AS hourblock, 				## We group by hourblock to aggregate meter values
		AVG(mv.metervalue) AS avg_metervalue, 				
        COUNT(mv.metervalue) AS count_metervalue			## Number of records averaged for each hour
        
	FROM MeterValue AS mv
	JOIN Meter AS m 
		ON mv.meterID = m.ID
	RIGHT JOIN Building AS b
		ON m.buildingID = b.ID

	GROUP BY hourblock, mv.MeterID, b.ID
	ORDER BY b.ID ASC, mv.meterID ASC, measuretime ASC
	;



## NORMALIZES WEATHER PER HOUR ##
DROP VIEW IF EXISTS v_Weather;
CREATE VIEW v_Weather AS

SELECT  
	ROUND(w.weatherdate*24)/24 AS measuretime, 			## Measurements are hourly, but extremely precise. This normalizes measurements to the hour, so we can sync with meter times
	ROUND(w.weatherdate*24) AS hourblock,					## We group by hourblock for weather
	AVG(w.wet_bulb_temp)	AS avg_wet_bulb_temp	, 
	AVG(w.temperature)		AS avg_temperature		, 
    AVG(w.real_humidity)	AS avg_real_humidity	, 
	AVG(w.dewpoint)			AS avg_dewpoint			, 
    AVG(w.wind_chill)		AS avg_wind_chill		, 
    AVG(w.pressure_inHg)	AS avg_pressure_inHg	, 
    AVG(w.wind_speed)		AS avg_wind_speed		, 
    AVG(w.wind_dir)			AS avg_wind_dir			, 
    AVG(w.rainfall)			AS avg_rainfall			,
    w.weatherstation								, 
    COUNT(w.record)			AS RecordCount
    
	FROM Weather AS w	
	JOIN WeatherStation AS ws 
		ON w.weatherstation = ws.ID

GROUP BY hourblock 
ORDER BY measuretime ASC, weatherstation ASC
;

