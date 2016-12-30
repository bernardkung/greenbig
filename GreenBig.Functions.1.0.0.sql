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
/* 		Functions												*/
/* 		Version 1.0.0											*/
/*==============================================================*/


use GreenBig;


## CONVERTS SERIAL TIME TO DATETIME ## 
DELIMITER //
DROP FUNCTION IF EXISTS undatenum //
CREATE FUNCTION undatenum(datenumber DECIMAL(11,5)) RETURNS datetime
BEGIN
DECLARE dntime 	time;
DECLARE dnday 	date;
DECLARE vdn timestamp;

  SET dntime = sec_to_time(mod(datenumber, 1)*86400);			## select DATENUMBER decimals, converts to time ##
  SET dnday  = from_days(floor(datenumber));					## select DATENUMBER integer as days from 0, converts to date ##
	
    SET vdn =  timestamp(dnday, dntime) ;						## combine into datetime ##
##	SET vdn =  convert(concat(dnday, ' ', dntime), datetime) ;
    RETURN (vdn);												## returns datetime ##

END;
//
DELIMITER ;




## CONVERTS DATETIME TO DATENUM ## 
DELIMITER //
DROP FUNCTION IF EXISTS datenum //
CREATE FUNCTION datenum(vdn datetime) RETURNS DECIMAL(11,5)		## IN datetime, out  datenum ##
BEGIN
DECLARE dn		DECIMAL(11,5);

	SET dn = CONVERT(TO_SECONDS(vdn)/86400, DECIMAL(11,5));
	
    RETURN dn;
END;
//
DELIMITER ;

