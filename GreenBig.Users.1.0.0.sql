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
/* 		User Creation and Granting Privileges					*/
/* 		Version 1.0.0											*/
/*==============================================================*/

use GreenBig;


/*==============================================================*/
/* Database Administrators                                      */
/*==============================================================*/
CREATE USER IF NOT EXISTS 
	'adminA'@'localhost' IDENTIFIED BY 'password'
	;
GRANT ALL PRIVILEGES 
	ON *.* 
    TO 'adminA'@'localhost'
	WITH GRANT OPTION;
  

## SHOW GRANTS FOR 'db_admin'@'localhost'; 
## SHOW GRANTS FOR 'db_admin'@'%'; 

/*==============================================================*/
/* Database Maintenance	                                        */
/*==============================================================*/
/*
CREATE USER IF NOT EXISTS 
	'db_maint'@'%' IDENTIFIED BY 'password'
	;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP
	ON GreenBig.* 
    TO 'db_maint'@'localhost'
	;
*/

##	SHOW GRANTS FOR 'user_class1'@'localhost';
/*==============================================================*/
/* Analyst				                                        */
/*==============================================================*/
CREATE USER IF NOT EXISTS
	'analyst'@'localhost' IDENTIFIED BY 'password'
    ;
GRANT SELECT 
	ON GreenBig.*
    TO 'analyst'@'localhost'
    ;

/*


*/

/*==============================================================*/
/* MeterValue Maintenance                                       */
/*==============================================================*/
CREATE USER IF NOT EXISTS
	'facilities'@'localhost' IDENTIFIED BY 'password'
    ;
GRANT SELECT, INSERT 
	ON GreenBig.MeterUpdate
	TO 'facilities'@'localhost'
    ;
GRANT SELECT
	ON GreenBig.v_buildingmeters
	TO 'facilities'@'localhost'
    ;    
GRANT SELECT
	ON GreenBig.v_meters
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_activemeters
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_CheckMeterUpdate
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_SiteMeterSum
	TO 'facilities'@'localhost'
    ;

## SHOW GRANTS FOR 'meter_update';

/*==============================================================*/
/* Facilities Management                                        */
/*==============================================================*/
CREATE USER IF NOT EXISTS
	'fac_admin'@'localhost' IDENTIFIED BY 'password'
    ;
GRANT SELECT, INSERT
	ON GreenBig.MeterUpdate
	TO 'facilities'@'localhost'
    ;
GRANT SELECT
	ON GreenBig.v_buildingmeters
	TO 'facilities'@'localhost'
    ;
GRANT SELECT 
	ON GreenBig.v_buildingequipment
	TO 'facilities'@'localhost'
    ;
GRANT SELECT 
	ON GreenBig.v_roomdirectory
	TO 'facilities'@'localhost'
    ;
GRANT SELECT
	ON GreenBig.v_meters
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_activemeters
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_BuildingMeterSum
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_CheckMeterUpdate
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_CancelUpdate
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_ConfirmUpdate
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_CountRoomTypeEquipment
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_EUI
	TO 'facilities'@'localhost'
    ;

GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_SiteMeterSum
	TO 'facilities'@'localhost'
    ;
GRANT EXECUTE
	ON PROCEDURE GreenBig.sp_TotalBuildingMeterSum
	TO 'facilities'@'localhost'
    ;



## SHOW GRANTS FOR 'fac_admin';



