--********************Queries********************************

--01 - view
--It creates a view that describes which person has reserved which hotel
--This view uses RPAD

--It tells which person has reserved which hotel
Drop view personHotel;
Create view personHotel as
    select RPAD(G.FirstName, 20, '.') Guest, R.hotelID
    from Guest G, Reservation R
    where R.personID = G.personID;

select * from personHotel;

--This query uses Length 
--It orders the credit cards based on length of name
select NameOnCard
from CreditCard
order by length(NameOnCard);


--************Demonstrate savepoints*************************
Insert into CreditCard 
values (4, 'Landon Evans', 4004564397607550, 'Visa', To_Date('01-2028', 'MM-YYYY'), 805);
Insert into CreditCard
values (4,'Robert Smith',5567296490637467, 'MasterCard', TO_DATE('04-2022', 'MM-YYYY'), 564);
select * from CreditCard order by NameOnCard;

savepoint A;

select * from CreditCard order by NameOnCard;

delete from CreditCard where PersonID = 4;

savepoint B;

select * from CreditCard;

rollback to savepoint A;

--**************************************************

--This query uses substr
select FirstName, LastName, substr(zipcode, 3)
from Guest;

--02 - view
--Use atleast two number functions
--Uses Groupby and Having
--This view uses the sum function
--It shows the total number of rooms in a hotel location but it only shows the hotels who have
--more than 10 rooms in the hotel
Drop view totalRooms;
Create view totalRooms as
    select HD.HotelID, sum(HD.totalRooms) TotalRooms
    from HotelDetails HD, Hotel H
    where HD.HotelID = H.HotelID
    Group by HD.HotelID
    Having sum(HD.totalRooms) > 10
    order by sum(HD.totalRooms);
    
select * from totalRooms;
select * from hotel;


--This query uses the count function
--It shows the total number of users or guests on file
select count(FirstName) TotalGuests
from Guest;


--********Date Functions*****************
--Use atleast two date functions
--This query extracts the year of date of expiry of credit card
--In case if the administrator wants to check which cards on file are expired
select NameOnCard, DoE
from CreditCard
where To_char(DoE, 'YYYY') = 2020;

--This query subtracts the two dates to determine the length of stay of a person
select ReservationID, RoomID, (checkoutDate - checkinDate) LengthofStay
from ReservationDetails;

--This query uses the Least function to find the checkin date from a set of two dates
select G.FirstName, Least(CheckinDate, CheckOutDate) CheckIN
from Guest G, ReservationDetails RD
where G.PersonID = RD.ReservationID;


--****************sub query***************************
--This query uses a subquery and right outer join and concatenation
--It shows the full name of the person who has paid for the reservation
select G.FirstName || ' ' || G.MiddleName || ' ' || G.LastName, R.StatusOfPayment
from Guest G right outer join Reservation R on G.PersonID = R.PersonID
where R.StatusOFPayment in (select StatusOfPayment from Reservation where StatusOfPayment = 'PAID');



--03 - view
--Creating a view
--Create a query to determine the total cost a person will have to pay 
--depending on the length of stay and the cost of room he is renting
Create view CostofStay as
    select R.ReservationID, ((R.checkoutDate - R.checkinDate) * RD.CostPerNight) CostOfStay
    from ReservationDetails R, RoomDetails RD
    where R.RoomID = RD.RoomID;

select * from CostOfStay;


--04 - view
--Create a view that shows the people who have not paid yet and replace the null
--values in ReservationDate by "Not Paid". The 'Not Paid' will change to a date once the
--payment has been processed
Create view NotPaid as
    select ReservationID, StatusOfPayment, 
    Decode(ReservationDate, null, 'Not Paid', ReservationDate) ReserveDate
    from Reservation;

select * from NotPaid;

--05 - view
--Create a view to see what credit cards on file are associated with each person
--Please keep in mind that a person reserving a hotel can have a different name on the
--credit card. For e.g a wife using her husband's credit card.
Drop view GuestCreditCard;
Create view GuestCreditCard as
    select G.FirstName || ' ' || G.MiddleName || ' ' || G.LastName Guest, CC.CreditCardNumber, 
        CC.NameOnCard, CC.CardType, CC.DOE
    from GUEST G full outer join CreditCard CC on G.PersonID = CC.PersonID;

select * from GuestCreditCard;    


-- This query uses natural join to join the hotel and the view totalRooms created above
--It shows which hotel has how many rooms
--It gives more details about the hotel
select *
from hotel natural Join totalRooms;

--*********************Use insert all and insert first***********************
--create a query to insert some promotional room types
--In case company wants to improve their hotel packages for holiday season
--I want to create Deluxe Room, Honeymoon suite, Penthouse suite

drop table Promotional;
Create table Promotional(
    RoomID number not null,
    Roomtype varchar(50) not null,
    SmokeFree varchar(10),
    RoomView varchar(10),
    CostPerNight varchar(20) not null
);

insert All
    into Promotional (RoomID, Roomtype, SmokeFree, RoomView, CostPerNight)
        values(6, 'Deluxe Room', SmokeFree, RoomView, '1000')
    into Promotional (RoomID, Roomtype, SmokeFree, RoomView, CostPerNight)
        values(7, 'Honeymoon Suite', SmokeFree, RoomView, '1500')
    into Promotional (RoomID, Roomtype, SmokeFree, RoomView, CostPerNight)
        values(8, 'Penthouse suite', SmokeFree, RoomView, '5000')
    select distinct RoomID, Roomtypes, SmokeFree, RoomView, CostPerNight
    from RoomDetails
    where smokefree = 'Both' and RoomVIEW = 'Yes';
    
select * from Promotional;

--Creating a table from another table
--To remove duplicate values from table promotional
--I created the table NewPromotional which follows the same structure as Promotional
--But it gets rid of the duplicate values
drop table NewPromotional;
Create table NewPromotional as
    select distinct RoomID, RoomType, SmokeFree, RoomView, CostPerNight
    from Promotional;
    
select * from NewPromotional;
    
--Insert First
--This query describes that based on the booking of holiday season extra vagant
--room, you either become a gold member or not. 
--The prices of our Penthouse and Honeymoon suites are greater than a 1000 and therefore
--they are only allowed to our gold members. They have special privileges.
insert First 
    when CostPerNight > 1000 then
        into NewPromotional values(RoomID, RoomType, SmokeFree, RoomView, 
            'You are gold member')
        select RoomID, RoomType, SmokeFree, RoomView, CostPerNight
        from NewPromotional;
        
select * from NewPromotional;
      
    
    
    
--*********************Use merge*************************
--First insret a new luxury room in promotional. Then based on this new room merge promotional
--with NewPromotional. It actually inserts the new luxury room into new promotional
Insert into Promotional values (9, 'Luxury King Suite', 'Both', 'City View', 10000);
select * from Promotional;

--Now I need to update my NewPromotional
merge into NewPromotional NP
using (select RoomID, RoomType, SmokeFree, RoomView, CostPernight from Promotional) P
    on (NP.RoomID = P.RoomID)
    when matched then
        update set NP.RoomType = P.RoomType
    when not matched then
        insert (NP.RoomID, NP.RoomType, NP.SmokeFree, NP.RoomView, NP.CostPerNight)
        values (P.RoomID, P.RoomType, P.SmokeFree, P.RoomView, P.CostPerNight);

select * from NewPromotional;

--Always keep the option of rollback in case you didn't want to undo things
rollback;

--**********************Update with Embedded Select*****************

--A person realizes that his name on card is the same as his own name
--He goes and edits his name. This query updates the row of that person based on his ID and 
--Creditcardnumber. His name on card was 'Kenneth Zang'. He had two cards on file. 
--Now he changed his name on one of his cards to his own name which is 'John R Smith'
update creditcard  set NameonCard = (select FirstName || ' ' || Middlename || ' ' || LastName from Guest where LastName = 'Smith' 
                                                                        and PersonID = 2)
where creditcardnumber = 4539258821440860;

select * from creditcard;



    
    







