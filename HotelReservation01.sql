ALTER SESSION SET ddl_lock_timeout=0;

--***********Purpose of Database*************

--This database is used for reserving a hotel room
--The users can login with their usernames and passwords which are stored in database
--They can look at the hotel location and rating and then choose the room type and 
--pay for their length of stay.

--*************Purpose of database***************


--*************Drop tables***********************

--drop table if already exists
Drop table CreditCard;
Drop table Reservation;
Drop table ReservationDetails;
Drop table HotelDetails;
Drop table Hotel;
Drop table RoomDetails;
Drop table GUEST;

--**************Create tables*********************

--For auto generation of PK create a sequence
Drop sequence Per_ID; --drop the sequence first

--This sequence is for autogeneration of primary key. It increments by 1.
Create sequence Per_ID increment by 1 start with 1;

--01 
--Guest
--This table stores all information related to guest
Create table GUEST(
    PersonID number,    --Primary Key
    FirstName varchar(50) not null,
    MiddleName varchar(50),
    LastName varchar(50) not null,
    Email varchar(50) not null unique,
    Password varchar(50) not null unique,
    HouseNo varchar(10) not null,
    Street varchar(20) not null,
    City varchar(20) not null,
    State varchar(2) not null,
    Zipcode number not null,

    Constraint person_PK PRIMARY KEY(PersonID)
); --end create table

--Create a Unique constraint 
--This constraint will always make sure that the combination is unique whenever
--the query runs. Two people can have same firstnames but the combination will always be unique

Alter table GUEST 
Add Constraint person_FirstName_unique UNIQUE (PersonID, FirstName);


--Incase I want to make changes to my table
--alter table GUEST drop constraint person_PK;

INSERT INTO GUEST values (Per_ID.Nextval, 'Nomaira', 'M', 'Javaed', 'nmjavaed@gmail.com',
                         'poi321', '23', 'Rose Ln', 'Detroit', 'MI', 48127);
INSERT INTO GUEST values (Per_ID.Nextval, 'John', 'R', 'Smith', 'jrs@gmail.com',
                         'uyt321', '40', 'Ivory ln', 'Chicago', 'IL', 60007);
INSERT INTO GUEST values (Per_ID.Nextval, 'Maria', null, 'Garcia', 'margar@gmail.com',
                         'rew098', '102', 'Wint Ln', 'Indianapolis', 'IN', 40007);
INSERT INTO GUEST values (Per_ID.Nextval, 'Robert', null, 'Smith', 'robs92@gmail.com',
                         'qlk765', '602', 'Kidd Avenue', 'Anchorage', 'Ak', 99503);
INSERT INTO GUEST values (Per_ID.Nextval, 'James', 'William', 'Johnson', 'james1980@gmail.com',
                         'jhg432', '402', 'Boring Ln', 'San Francisco', 'CA', 94103);

--02
--Credit Card
--This table stores the credit card information of a guest

Create table CreditCard(
    PersonID number,    --Foreign Key
    NameOnCard varchar(50) not null,
    CreditCardNumber int not null,
    CardType varchar(50) not null,
    DoE date not null,
    CVV int not null,

    Constraint CC_PersonID_FK FOREIGN KEY(PersonID) References GUEST(PersonID)
);

--Create an index to make sure the combination of PersonID and CVV is always unique
--This makes sure that a credit card information is not repeated
--One person can have many credit cards but they have to be different
Drop index CC_personID_CVV;
Create unique index CC_personID_CVV on CreditCard (PersonID, CVV);

select * from all_indexes;

--In case I want to make changes to my table
--alter table CreditCard drop constraint CC_PersonID_FK;

INSERT INTO CreditCard values (1,'Nomaira M Javaed',3530111333300000, 'JCB', 
                    TO_DATE('12-2020', 'MM-YYYY'), 432);
INSERT INTO CreditCard values (2,'Kenneth Zang',4539258821440860, 'Visa', 
                    TO_DATE('08-2020', 'MM-YYYY'), 621);
INSERT INTO CreditCard values (3,'Maria Garcia',5468758423288668, 'MasterCard', 
                    TO_DATE('03-2022', 'MM-YYYY'), 793);
INSERT INTO CreditCard values (4,'Robert Smith',5567296490637467, 'MasterCard', 
                    TO_DATE('04-2022', 'MM-YYYY'), 564);
INSERT INTO CreditCard values (5,'James WIlliam Johnson',5567296490637467, 'MasterCard', 
                    TO_DATE('04-2022', 'MM-YYYY'), 966);
INSERT INTO CreditCard values (1,'Emmy Thomas',4302675885427175, 'Visa', 
                    TO_DATE('04-2021', 'MM-YYYY'), 828);
INSERT INTO CreditCard values (2,'Kenneth Zang',4476025037562026, 'Visa', 
                    TO_DATE('12-2019', 'MM-YYYY'), 850);
INSERT INTO CreditCard values (3,'Karissa Young',4355007420403378, 'Visa', ``
                    TO_DATE('08-2024', 'MM-YYYY'), 375);
select * from CreditCard;

--03
--Hotel
--Create a table for hotel that describes the location and rating of hotel
--FAWN hotel has many locations
--User choose the hotel based on the location and rating of the hotel



Drop sequence hotelID_seq;
Create sequence hotelID_seq increment by 1 start with 1;

Create table HOTEL(
    HotelID number, --Primary Key
    Street varchar(50) not null,
    City varchar(20) not null,
    State varchar(2) not null,
    Zipcode number not null,
    Rating number,
    
    
    Constraint hotel_pk PRIMARY KEY (HotelID)
);

Alter table HOTEL 
Add Constraint rating_check CHECK(Rating between 1 and 5); --make sure rating is btw 1 and 5

INSERT into HOTEL values(hotelID_seq.nextval, '880 Steele St', 'Chicago', 'IL', 60605, 4);
INSERT into HOTEL values(hotelID_seq.nextval, '2676 Water St', 'San Jose', 'CA', 95134, 5);
INSERT into HOTEL values(hotelID_seq.nextval, '4548 Dovetail Estates', 'Kingfisher', 'OK', 73750, 3);
INSERT into HOTEL values(hotelID_seq.nextval, '1410 White River Way', 'Salt Lake City', 'UT', 84104, 3);
INSERT into HOTEL values(hotelID_seq.nextval, '559 Bobcat Dr', 'Annapolis', 'MD', 21401, 4);
INSERT into HOTEL values(hotelID_seq.nextval, '2514 Trouser Leg Rd', 'Waukesha', 'WI', 53186, 2);
INSERT into HOTEL values(hotelID_seq.nextval, '767 Lost Creek Rd', 'Philadelphia', 'PA', 19108, 4);
INSERT into HOTEL values(hotelID_seq.nextval, '3400 Deer Ridge Dr', 'Rochelle Park', 'NJ', 07662, 5);
INSERT into HOTEL values(hotelID_seq.nextval, '280 Florence St', 'Dallas', 'TX', 75247, 5);


--04
--RoomDetails
--Create table RoomDetails to describe the room types available in above hotels
--This table


Drop sequence roomID_seq;
Create sequence roomID_seq increment by 1 start with 1;

Create table RoomDetails(
    RoomID number, --Primary Key
    RoomTypes varchar(50),
    SmokeFree varchar(10),
    RoomView varchar(10),
    MaxCount number,
    CostPerNight    number,
    
    Constraint Room_ID_PK PRIMARY KEY (RoomID)
);

INSERT into RoomDetails values (roomID_seq.nextval, 'Queen bed', 'Both', 'Yes', 2, 250);
INSERT into RoomDetails values (roomID_seq.nextval, 'King Bed', 'Both', 'No', 2, 350);
INSERT into RoomDetails values (roomID_seq.nextval, 'Double Queen bed', 'No', 'No', 4, 400);
INSERT into RoomDetails values (roomID_seq.nextval, 'Double King bed', 'No', 'Yes', 4, 500);
INSERT into RoomDetails values (roomID_seq.nextval, 'Double Twin bed', 'Both', 'Yes', 2, 250);


--05
--Create table HotelDetails which describes the available number of rooms
--of a particular type in a specific location of hotel

Create table HotelDetails(
    HotelID number, --Foreign Key
    RoomID number,  --Foreign Key
    TotalRooms number,
    
    Constraint hotelDet_HotelID_FK FOREIGN KEY (HotelID) References Hotel (HotelID),
    Constraint hotelDet_RoomID_FK FOREIGN KEY (RoomID) References RoomDetails(RoomID)

);

INSERT INTO HotelDetails values (1, 3, 10);
INSERT INTO HotelDetails values (5, 1, 15);
INSERT INTO HotelDetails values (8, 5, 12);
INSERT INTO HotelDetails values (5, 4, 20);
INSERT INTO HotelDetails values (5, 2, 10);
INSERT INTO HotelDetails values (2, 2, 14);
INSERT INTO HotelDetails values (3, 4, 12);
INSERT INTO HotelDetails values (4, 3, 15);
INSERT INTO HotelDetails values (4, 2, 10);
INSERT INTO HotelDetails values (4, 5, 20);
INSERT INTO HotelDetails values (6, 4, 10);
INSERT INTO HotelDetails values (7, 2, 14);
INSERT INTO HotelDetails values (8, 2, 10);
INSERT INTO HotelDetails values (9, 3, 10);
INSERT INTO HotelDetails values (9, 1, 10);
INSERT INTO HotelDetails values (9, 4, 10);
INSERT INTO HotelDetails values (9, 5, 10);


--06
--Create a table Reservation that describes which person reserved which hotel
--and what is the status of payment and reservation date

Drop table Reservation;

Drop sequence reserv_seq;
Create sequence reserv_seq increment by 1 start with 1;

Create table Reservation(
    ReservationID number,  --Primary key
    PersonID number,    --Foreign Key
    HotelID number,     --Foreign Key
    StatusOfPayment varchar(20),
    ReservationDate date,

    Constraint ReservID_PK PRIMARY KEY (ReservationID),
    Constraint reserv_hotelID_reservation_FK FOREIGN KEY (HotelID) References HOTEL(HotelID),
    Constraint reserv_personID_reservation_FK FOREIGN KEY (PersonID) References GUEST(PersonID)
);
alter table Reservation drop constraint ReservID_PK;
alter table Reservation drop constraint reserv_hotelID_reservation_FK;
alter table Reservation drop constraint reserv_personID_reservation_FK;


INSERT into Reservation values (reserv_seq.nextval, 3, 4, 'PAID', 
                To_Date('01-02-2019', 'MM-DD-YYYY'));
INSERT into Reservation values (reserv_seq.nextval, 1, 2, 'PAID', 
                To_Date('03-12-2018', 'MM-DD-YYYY'));
INSERT into Reservation values (reserv_seq.nextval, 5, 8, 'IN PROCESS', 
                null);
INSERT into Reservation values (reserv_seq.nextval, 2, 6, 'IN PROCESS', 
                null);
INSERT into Reservation values (reserv_seq.nextval, 4, 7, 'PAID', 
                To_Date('02-20-2019', 'MM-DD-YYYY'));
            

--07
--ReservationDetails
--Create table ReservationDetails that describes who booked which room in which
--hotel. The reservationID encompasses the personID and hotelID.
--checkin and checkout dates
Drop table ReservationDetails;
Create table ReservationDetails(
    ReservationID number not null,       --Foreign Key
    RoomID number not null,              --Foreign Key
    CheckInDate date,
    CheckOutDate date,
    
    Constraint reservDet_reservID_FK FOREIGN KEY (ReservationID) References Reservation (ReservationID),
    Constraint resrevDet_roomID_FK FOREIGN KEY (RoomID) References RoomDetails(RoomID)
);

INSERT into ReservationDetails values (1, 2, To_Date('04-15-2019', 'MM-DD-YYYY'),
                    To_Date('04-18-2019', 'MM-DD-YYYY'));
INSERT into ReservationDetails values (2, 4, To_Date('05-01-2019', 'MM-DD-YYYY'),
                    To_Date('05-03-2019', 'MM-DD-YYYY'));
INSERT into ReservationDetails values (3, 3, To_Date('06-15-2019', 'MM-DD-YYYY'),
                    To_Date('06-18-2019', 'MM-DD-YYYY'));
INSERT into ReservationDetails values (4, 1, To_Date('03-20-2019', 'MM-DD-YYYY'),
                    To_Date('03-24-2019', 'MM-DD-YYYY'));
INSERT into ReservationDetails values (5, 5, To_Date('03-24-2019', 'MM-DD-YYYY'),
                    To_Date('03-30-2019', 'MM-DD-YYYY'));

select * from GUEST;
select * from CreditCard;
select * from Hotel;
select * from RoomDetails;
select * from HotelDetails;
select * from Reservation;
select * from ReservationDetails;

--Check all constraints created by me

select * 
from user_constraints a, user_cons_columns b ,user_tab_columns c 
where  a.table_name = b.table_name 
and a.constraint_name = b.constraint_name 
and b.table_name = c.table_name 
and b.column_name = c.column_name 
and a.owner='NJAVAED'