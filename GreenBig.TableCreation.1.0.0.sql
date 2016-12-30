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
/* 		Database Definition										*/
/* 		Version 1.0.0											*/
/*==============================================================*/


DROP DATABASE IF EXISTS GreenBig;
CREATE DATABASE GreenBig;
USE GreenBig;

/*==============================================================*/
/* Table: State                                                 */
/*==============================================================*/
create table State (
	Id					varchar(2)			not null,
	StateName			varchar(20)			not null,
    
	primary key (ID)
);

/*==============================================================*/
/* Table: City                                                  */
/*==============================================================*/ 
create table City (
	ID					int					not null auto_increment,
    CityName			varchar(40)			not null,
    StateID				varchar(2)			not null,
    
    primary key (ID),
    foreign key (StateID) REFERENCES State(ID)
);

/*==============================================================*/
/* Table: University                                            */
/*==============================================================*/
create table University (
	ID					int					not null auto_increment,
    University_PF       varchar(5)        null,
    UniversityName		varchar(100)		not null,

    
	primary key (ID)

);

/*==============================================================*/
/* Table: BUILDINGTYPE                                          */
/*==============================================================*/
create table BUILDINGTYPE(
    TYPENAME       		varchar(20)        not null,
	primary key (TYPENAME)
);

/*==============================================================*/
/* Table: UNIVERSITYSITE                                        */
/*==============================================================*/
create table UNIVERSITYSITE(
	ID					int			  		not null auto_increment,
    SITENAME       		varchar(20)        	not null,
    UniversityID    	int        			not null,
    CityID				int					not null,
    
	primary key (ID),
    foreign key (UniversityID) references University(ID),
	foreign key (CityID) references City(ID)
);




/*==============================================================*/
/* Table: Director                                              */
/*==============================================================*/
create table Director (
	ID					int					not null auto_increment,
    FirstName			varchar(20)			,		## optional? ##
    LastName			varchar(20)			,		## optional? ##
    Email				varchar(40)			,		## optional? ##
    Phone				varchar(14)			,		## optional? data type? ##
    
    primary key (ID)
);


/*==============================================================*/
/* Table: Departmentlist                                        */
/*==============================================================*/
create table Departmentlist (
	ID					varchar(2)			not null,
    DeptName_PF			varchar(9)			not null,
	DeptName			varchar(40)			not null,

    
    primary key (ID)
	-- foreign key (SchoolID) references School(ID),
    -- foreign key (DirectorID) references Director(ID)
);

/*==============================================================*/
/* Table: WeatherStation                                        */
/*==============================================================*/
create table WeatherStation (
	ID					int					not null auto_increment,
    StationName			varchar(20)			,
    StationDesc			varchar(40)			,
    CityID				int					not null,
    
    primary key (ID),
    foreign key (CityID) references City(ID)
);

/*==============================================================*/
/* Table: Weather                                               */
/*==============================================================*/
create table Weather (
	Record				int				not null,
    WeatherDate			decimal(11,5)		not null,
	Wet_Bulb_Temp		decimal(5,2)		,						## data types undecided, not enough meteorological background ##
    temperature			decimal(5,2)		,						
    real_humidity		decimal(5,2)	    ,
    dewpoint			decimal(5,2)		, 						## same data type as real_humidity
	wind_chill			decimal(5,2)		,						## same data type as temperature		
	pressure_inHg		decimal(5,2)		,						## barometric pressure is not always reported with the same units: atmospheres (atm) millibars (mb) pascals (Pa) inches of mercury (in), pounds per square inch (PSI) etc ##
    wind_speed			decimal(5,2)		,
	wind_dir			decimal(5,2)		,
    rainfall			decimal(5,2)		,
    weatherstation		int					not null,
    
    primary key (weatherstation,WeatherDate),
    foreign key (weatherstation) references WeatherStation(ID)
);

/*==============================================================*/
/* Table: Building                                              */
/*==============================================================*/
#DROP TABLE `greenbig`.`building`;
CREATE TABLE Building (
    ID 				VARCHAR(6)	 	NOT NULL,
    BuildingName 	VARCHAR(64)	 	NOT NULL,
    UniversityID 	INT 	     	NOT NULL,
    TypeID 			VARCHAR(20)		,
    SiteID 			INT				,
    CampusID 		INT				,
    Address_Street 	VARCHAR(64)		,
    ZIP_Code 		VARCHAR(5)		,
    ConstructYear 	YEAR			,
    OccDate 		VARCHAR(12)		,   #CONVERT(VARCHAR(19),GETDATE())
    Owned      		tinyint(1)		,
    Height    		decimal(4,1)	,
    LATITUDE_WGS 	Decimal(9,6)	,
    LONGITUDE_WGS 	Decimal(9,6)	,
    wh_load_date    VARCHAR(12)		,   #CONVERT(VARCHAR(19),GETDATE())
    PRIMARY KEY (ID),
    FOREIGN KEY (UniversityID) REFERENCES University (ID)
);



/*==============================================================*/
/* Table: Assign Weatherstation to Building						*/
/*==============================================================*/
create table Buildingweather (
	ID			    int		            not null auto_increment,
    BuildingID		varchar(6)			not null,
    WeatherStationID	int			not null,

    
    primary key (ID),
    foreign key (WeatherStationID) references WeatherStation(ID),
    foreign key (BuildingID) references Building(ID)
);



/*==============================================================*/
/* Table: RoomMajorUsage                            		    */
/*==============================================================*/
create table RoomMajorUsage (										## Generalizes room types, one RoomMajorUsage has several RoomTypes  ##
	ID					VARCHAR(2)			not null,
    MajorUsageShort		varchar(8)			not null,
    MajorUsage			varchar(20)			not null,
    Assignable          tinyint(1)			,
    
    primary key (ID)
);
/*==============================================================*/
/* Table: RoomType                                              */
/*==============================================================*/
create table RoomType (												## Defines what kind of room, e.g. lecture hall, laboratory, office ##
	ID					VARCHAR(2)			not null,
    RoomType			varchar(20)			not null,
    RoomMajorUsageID	VARCHAR(2)			not null,
    
    primary key (ID),
    foreign key (RoomMajorUsageID) references RoomMajorUsage(ID)
);
/*==============================================================*/
/* Table: BuildingFloor                                         */
/*==============================================================*/

create table buildingfloor (										## renamed, floor is a mysql command ##
	ID					VARCHAR(8)				not null,
	BuildingID			VARCHAR(6)					not null,
    Floornumber			int		not null,				## 
    Structural_SQF		int					not null default 0, 	
		constraint chk_floor_size CHECK (Structural_SQF>=0),		## no negative square footages ##

    
    primary key (ID),
    foreign key (BuildingID) references Building(ID)
);
/*==============================================================*/
/* Table: RoomDescription                                       */
/*==============================================================*/
create table RoomDesc (
	buildingFloorID		varchar(8)			not null,
    ID					varchar(10)			not null,
    Room_SQF			int					not null default 0,	
    RoomUsageID			varchar(2)			,
    DeptID				varchar(2)			not null,
    
##		constraint chk_room_size CHECK (Room_SQF>=0),					## no negative square footages ##

    primary key (ID),
    foreign key (RoomUsageID) references RoomType(ID),
    foreign key (buildingFloorID) references buildingfloor(ID),
    foreign key (DeptID) references Departmentlist(ID)
);


/*==============================================================*/
/* Table: EquipmentSubType                                      */
/*==============================================================*/
create table EquipmentSubType (
	ID					int					not null,
    EqptSubType			varchar(40)			,							## names classes of equipment types, optional ##

	primary key (ID)
);


/*==============================================================*/
/* Table: EquipmentType                                         */
/*==============================================================*/
create table EquipmentType (
	ID					int					not null,
    EquipmentSubTypeID	int					not null,
    EqptTypeName		varchar(40)			,							## names equipment type, optional ##		
    EqptTypeDscptn		varchar(40)			,							## describes equipment type, optional ## 

	primary key (ID),
    foreign key (EquipmentSubTypeID) references EquipmentSubType(ID)
);


/*==============================================================*/
/* Table: Equipment                                             */
/*==============================================================*/

create table Equipment (
	EquipmentName		varchar(40)			not null,
    EquipmentTypeID		int					not null,
    BuildingID			varchar(6)			not null,
    
    primary key (EquipmentName),
    foreign key (EquipmentTypeID) references EquipmentType(ID)    #foreign key (BuildingID) references Building(ID)
);


/*==============================================================*/
/* Table: EquipmentList                                         */
/*==============================================================
create table EquipmentList (
	EqptTagName			varchar(20)			not null,
    EquipmentID			int					not null,
    BuildingID				varchar(10)			not null,
    
    primary key (EqptTagName),
    foreign key (BuildingID) references Building(ID),
    foreign key (EquipmentID) references Equipment(ID)
);*/


/*==============================================================*/
/* Table: Resource                                              */
/*==============================================================*/

create table Resource (
	ID					int					not null auto_increment,
    ResourceName		varchar(40)			not null,				## based on charlength of electricity, chill_water, steam ##			

	primary key (ID)
);
/*==============================================================*/
/* Table: Meter                                                 */
/*==============================================================*/
create table Meter (
	ID					int					not null auto_increment,
    MeterTagName		char(20)			not null,				
    BuildingID			VARCHAR(6)			not null,
    ResourceID			int					not null,
    
    primary key (ID),
    foreign key (BuildingID) references Building(ID),
    foreign key (ResourceID) references Resource(ID)
);

/*==============================================================*/
/* Table: Meter Value                                           */
/*==============================================================*/
create table MeterValue (
	Record				int				not null auto_increment,
    MeterID 			int					not null,
    MeasureTime			decimal(11,5)		not null,						
    MeterValue			float				,
    -- Max_Setpoint		int					,						
    -- Min_setpoint		int					,						

	primary key (Record),
    foreign key (MeterID) references Meter(ID)
);


/*==============================================================*/
/* Table: Meter Update                                          */
/*==============================================================*/
drop table if exists MeterUpdate;
create table MeterUpdate (
	Record				int				not null,
    MeterID 			int					not null,
    MeasureTime			decimal(11,5)		not null,						
    MeterValue			float				,
	wh_LoadDate			timestamp			default current_timestamp,

	primary key (Record)
);



/*==============================================================*/
/* Table: Bin Year Built                                        */
/*==============================================================*/
   create table yearbuiltbin	(
   ID					int					not null auto_increment,
   FromYear				year				not null,
   ToYear				year				not null,
   primary key (ID)
   );    

/*==============================================================*/
/* Table: BostonBenchmark                                       */
/*==============================================================*/
create table BostonBenchmark (
	ID					varchar(2)			not null,
    RoomMajorUsage		varchar(2)			not null,
    YearBuiltType		int					not null,			
    SiteEUI				decimal(5,2)		,
	ElectricityEUI		decimal(5,2)		,
    ChillWaterEUI		decimal(5,2)		,
    SteamEUI			decimal(5,2)		,
    
    primary key (ID),
    foreign key (RoomMajorUsage) references RoomMajorUsage(ID),
    foreign key (yearbuilttype) references yearbuiltbin(ID)
);
   
drop table if exists historicalbenchmark;
/*==============================================================*/
/* Table: HistoricalBenchmark                                   */
/*==============================================================*/
create table HistoricalBenchmark (
	monthID				int					,			
    temp				decimal(7,4)		,
	DailyChillWater		decimal(7,4)		,
    DailySteam			decimal(7,4)		,
    DailyElectricty		decimal(7,4)		,
    buildingID			varchar(6)			not null,
    
    primary key (monthID)
);
    
