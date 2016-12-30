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
/* 		Load Data Scripts										*/
/* 		Version 1.0.0											*/
/*==============================================================*/

SET SQL_SAFE_UPDATES = 0;

INSERT INTO State  VALUES ('MA','Massachusetts');

INSERT INTO City (CityName, StateID)  VALUES ('Cambridge','MA');

INSERT INTO University (University_PF,UniversityName)  VALUES ('MIT','Massachusetts Institute of Technology');

INSERT INTO BUILDINGTYPE VALUES ('ACADEMIC'),('RESIDENT'),('SERVICE');

INSERT INTO UNIVERSITYSITE(SITENAME,UniversityID, CityID) VALUES ('EAST',1,1),('EASTEAST',1,1),('MAIN GROUP',1,1),('NORTH',1,1),('NORTHEAST',1,1),
('NORTHWEST',1,1),('OFFCAMPUS',1,1),('WEST',1,1),('WESTWEST',1,1);

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/Departmentlist.csv' INTO TABLE Departmentlist FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;

INSERT INTO WeatherStation VALUES (1,'Cambridge station','It is provided with ICETECH',1);

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/weather2.csv' INTO TABLE Weather FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/buildings.csv' INTO TABLE Building FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/majtype.csv' INTO TABLE RoomMajorUsage FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/roomtype.csv' INTO TABLE RoomType FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;



INSERT INTO Resource(ResourceName) VALUES ('BuildingCHWCoolingEnergy_M'),('BuildingCHWCoolingRate_M'),('BuildingElectricEnergy_M'),('BuildingHWHeatingEnergy_M'),('BuildingHWHeatingRate_M'),
('BuildingSteamEnergy_M'),('BuildingSteamFlow_M'),('SubmeterCHWCoolingRate_M'),('SubmeterElectricEnergy_M'),('SubmeterElectricPower_M'),('SubmeterSteamFlow_M');

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/meter.csv' INTO TABLE meter FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/b13.csv' INTO TABLE MeterValue FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/b14.csv' INTO TABLE MeterValue FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/b24.csv' INTO TABLE MeterValue FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/b26.csv' INTO TABLE MeterValue FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/b18.csv' INTO TABLE MeterValue FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/b16.csv' INTO TABLE MeterValue FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/floor.csv' INTO TABLE buildingfloor FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/allroom.csv' INTO TABLE RoomDesc FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/equipmenttype.csv' INTO TABLE EquipmentSubType FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/equipmentsubtype.csv' INTO TABLE EquipmentType FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/equipment.csv' INTO TABLE Equipment FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ;



LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/yearbuilt.csv' INTO TABLE YearBuiltBin FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ;

LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/BOSTON BENCHMARK.csv' INTO TABLE BostonBenchmark FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ;
LOAD DATA LOCAL INFILE 'C:/Users/behnam/Downloads/Final Candidate Code/Final Candidate Code/import data/Historical Benchmark.csv' INTO TABLE HistoricalBenchmark FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ;

