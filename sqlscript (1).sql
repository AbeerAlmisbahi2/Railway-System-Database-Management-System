create table Train ( 
  train_name varchar2(50), 
  train_id   number not null, 
  speed   number, 
constraint pk_Train  primary key (train_id) 
);

INSERT INTO Train (train_name , train_id , speed)  
VALUES ('SARI', 101, 200);

INSERT INTO Train (train_name , train_id , speed)  
  WITH names AS (  
    SELECT 'SAR2',   102,     140 FROM dual UNION ALL  
    SELECT 'SAR3',   103,     80   FROM dual UNION ALL  
    SELECT 'SAR4',   104,     100 FROM dual UNION ALL  
    SELECT 'SAR5',   105,     95 FROM dual  
  )  
  SELECT * FROM names;

SELECT * FROM Train;

create table Station ( 
  station_code   number not null, 
  station_name varchar2(50), 
   
constraint pk_Station  primary key (station_code) 
);

INSERT INTO Station (station_code  , station_name)  
  WITH names AS (  
    SELECT 01, 'Makkah Station'    FROM dual UNION ALL  
    SELECT 02, 'Jeddah Station'   FROM dual UNION ALL  
    SELECT 03, 'Madinah Station' FROM dual UNION ALL  
    SELECT 04, 'Riyadh Station'  FROM dual  
  )  
  SELECT * FROM names;

SELECT * FROM Station;

create table Schedule ( 
  trip_code   number not null, 
  DepartCity   varchar2(20), 
  ArrivalCity    varchar2(20), 
  DepartTime  varchar2(20), 
  Distance       number, 
  Price             number, 
  Seat      varchar2(20), 
  train_id   number not null, 
  station_code   number not null, 
 
constraint pk_Schedule   primary key (trip_code), 
constraint fk_Schedule_Train foreign key (train_id ) references Train (train_id), 
constraint fk_Schedule_Station foreign key (station_code ) references Station (station_code ) 
 
);

INSERT INTO Schedule (trip_code ,station_code ,train_id,  DepartCity ,  ArrivalCity, DepartTime, Distance, Price, Seat)  
  WITH names AS (  
    SELECT 110, 01,102,  'Jeddah',    ' Makkah', '13:30:00 PM' ,  84   ,80, 'Available'   FROM dual UNION ALL  
    SELECT 111, 01,102,  'Jeddah',    ' Makkah', '13:30:00 PM' ,  84   ,80, 'Available'   FROM dual UNION ALL  
    SELECT 120, 02, 103, 'Makkah',   'Madinah', '10:40:00 AM' ,  434,   180, 'Reserved'  FROM dual UNION ALL  
    SELECT 130,03,104, ' Riyadh',    'Jeddah',     '14:54:00 PM' ,  952, 200, 'Available'   FROM dual UNION ALL  
    SELECT 140, 04,105, ' Madinah',    ' Riyadh',  '09:20:00 AM',  824,  230, 'Reserved' FROM dual  
  )   
SELECT * FROM names;

SELECT * FROM Schedule ;

create table Traveler ( 
TravelerID number not null, 
FName varchar2(20), 
LName varchar2(20), 
Phone number, 
Age number, 
Gender varchar(10), 
 
constraint pk_Traveler primary key (TravelerID) 
);

INSERT INTO Traveler (TravelerID, FName, LName, Phone, Age, Gender )  
  WITH names AS (  
    SELECT  1234, 'Rahaf', 'Abdulwahed', 0565623542, 20, 'F'    FROM dual UNION ALL  
    SELECT   5678, 'Abeer', 'Abdulmohsin', 0592323543, 20, 'F'   FROM dual UNION ALL  
    SELECT   2345, 'Sami',  'Salah', 0545623542, 45, 'M'  FROM dual UNION ALL  
    SELECT   6746, 'Eman', 'Wael', 0505624552, 65, 'M'   FROM dual  
  )  
  SELECT * FROM names;

SELECT * FROM Traveler ;

create table Ticket ( 
  TicketID    varchar2(20) not null, 
  TravelerID number not null, 
  trip_code   number not null, 
  TDate       varchar2(20), 
  TripNo      number not null, 
   
constraint pk_Ticket  primary key (TicketID ), 
constraint fk_Ticket_Traveler foreign key (TravelerID  ) references Traveler (TravelerID ), 
constraint fk_Ticket_Schedule  foreign key (trip_code) references Schedule (trip_code) 
 
);

INSERT INTO Ticket (TicketID,TravelerID,trip_code, TDate , TripNo)  
  WITH names AS (  
    SELECT '2A',1234,110, '1-12-2024' ,22    FROM dual UNION ALL  
    SELECT '2B',5678,120, '13-5-2018' ,23    FROM dual UNION ALL  
    SELECT '2C',2345,130, '11-6-2020' ,24   FROM dual UNION ALL  
    SELECT '2D',6746,140, '1-2-2018' ,25    FROM dual  
  )  
  SELECT * FROM names;

SELECT * FROM Ticket ;

SELECT * FROM Train;

SELECT * FROM Station;

SELECT DepartCity , ArrivalCity , DepartTime , Distance , Price  
FROM Schedule 
WHERE trip_code = 110;

SELECT TravelerID , FName , LName , Phone, Age, Gender FROM Traveler;

SELECT TicketID,TravelerID,trip_code, TDate , TripNo 
FROM Ticket  
WHERE TDate = '1-2-2018';

SELECT * 
FROM Ticket  
WHERE TravelerID = 1234;

SELECT s.trip_code, t.train_name, s.DepartCity, s.ArrivalCity, s.DepartTime 
FROM Schedule s 
JOIN Train t ON s.train_id = t.train_id 
WHERE s.trip_code IN ( 
    SELECT trip_code 
    FROM Ticket 
    WHERE TDate = '11-6-2020' 
);

SELECT DepartCity ,ArrivalCity, count (*) Seat 
FROM Schedule  
WHERE Seat = 'Available' 
GROUP BY DepartCity, ArrivalCity;

SELECT * FROM Schedule  ;

SELECT SUM(s.Price) AS TotalRevenue 
FROM Schedule s 
JOIN Ticket t ON s.trip_code = t.trip_code 
WHERE t.TDate BETWEEN '1-2-2018' AND  '13-5-2018' 
;

SELECT AVG(speed) AS average_speed 
FROM Train;

SELECT DepartCity, ArrivalCity  
FROM Schedule 
having  COUNT(*) > 1 
GROUP BY DepartCity, ArrivalCity;

SELECT * 
FROM Schedule 
ORDER BY DepartTime;

SELECT Train.train_id , SUM(Distance ) AS Distance  
FROM Train 
INNER JOIN Schedule ON Train.train_id  = Schedule.train_id  
GROUP BY Train.train_id ;

SELECT Schedule.trip_code, COUNT(Ticket.TicketID ) AS total_tickets_booked 
FROM Schedule 
LEFT JOIN Ticket ON Schedule.trip_code = Ticket.trip_code 
WHERE Schedule.Seat = 'Reserved' 
GROUP BY Schedule.trip_code;

