Create database PetPals

Create Table Pets (
PetID int identity Primary Key,
Name Varchar(100),
Age int,
Breed Varchar(100),
Type Varchar(100),
AvailableForAdoption Bit Default 1,
ShelterID int,
Foreign Key (ShelterID) references Shelters(ShelterID))

Create Table Shelters (
ShelterID int identity Primary Key,
Name Varchar(100),
Location Varchar(100))

Create Table Donations (
DonationID int identity Primary key,
DonorName Varchar(100),
DonationType varchar(100),
DonationAmount Decimal(10,2),
DonationItem Varchar(100),
DonationDate Date,
ShelterID int,
Foreign Key (ShelterID) references Shelters(ShelterID))

Create Table AdoptionEvents (
EventID int identity primary key,
EventName Varchar(100),
EventDate Date,
Location Varchar(100),
ShelterID int,
Foreign Key (ShelterID) References Shelters(ShelterID))

Create Table Participants (
ParticipantID int identity Primary Key,
ParticipantName Varchar(50),
ParticipantType Varchar(100),
EventID int,
Foreign Key (EventID) references AdoptionEvents(EventID))

Create Table Adoptions (
    AdopterID int identity Primary Key,
    ParticipantID int,
	PetID int,
    Foreign key(PetID) references Pets(PetID),
    Foreign key (ParticipantID) references Participants(ParticipantID))
	
insert into Shelters(Name, Location)
Values
      ('Animal Shelter','Wall Street'),
	  ('Pets Shelter','Gandhi Street'),
	  ('Help Pet Shelter','ClockTower Street'),
	  ('Safe Pet Shelter','Walk Street')
	  
insert into Pets (Name,Age,Breed,Type,AvailableForAdoption,ShelterID) 
Values
      ('Rock',5,'Bulldog','Dog',1,1),
	  ('Milo',4,'Persian','Cat',1,1),
	  ('Max',3,'Golden Retriever','Dog',1,2),
	  ('Buddy',3,'Poodle','Dog',0,3),
	  ('Charlie',2,'Siamese','Cat',1,4)

Insert into Donations (DonorName,DonationType,DonationAmount,DonationItem,DonationDate,ShelterID)
values
      ('Joe', 'Cash', 1200,Null,'2024-10-06',1),
	  ('John', 'Item', Null,'Pet Food','2024-10-26',2),
	  ('Tomson', 'Item',Null,'Pet Shampoo','2024-10-17',3),
	  ('Chris', 'Cash', 1900,Null,'2024-10-29',1),
	  ('David', 'Cash', 2000,Null,'2024-10-21',4)

insert into AdoptionEvents (EventName,EventDate,Location,ShelterID)
Values     
       ('Pet Adoption','2024-09-06','Central Park',1),
	   ('Pet Fest','2024-10-12','Central Park',2),
	   ('Pet Festival','2024-08-13','Central Park',3),
	   ('Pet Holiday','2024-09-28','Central Park',4)

Insert into Participants (ParticipantName,ParticipantType,EventID)
Values
      ('joe','Adopter',1),
	  ('David','Adopter',3),
	  ('Tomson','Adopter',4),
	  ('Animal Shetler','Shelter',2),
	  ('Help Pet Shelter','Shelter',1)

Insert into Adoptions(PetID,ParticipantID)
Values
(3, 1),  
(5, 4)

--5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption) from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that the query filters out pets that are not available for adoption.
Select
      Name,Age,Breed,type
From 
     Pets
Where AvailableForAdoption=1

--6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query joins the necessary tables to retrieve the participant names and types
Declare @EventID int=2 
Select 
      P.ParticipantName,
	  P.ParticipantType
From 
     Participants as P
Join AdoptionEvents as Ae on P.EventID=Ae.EventID
Where Ae.EventID =@EventID

--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table. The result should include the shelter name and the total donation amount. Ensure that the query handles cases where a shelter has received no donations.
Select
      S.Name,
	  Sum(D.DonationAmount) as TotalDonationAmount
From Shelters as S
Join Donations as D on S.ShelterID=D.ShelterID
Group by S.ShelterID, S.Name
Order by S.Name

--9.Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result set.
Alter table Pets
Add OwnerID Int default 0

Select Name,Age,Breed,Type
From Pets
Where OwnerID is Null

--10.Write an SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) from the "Donations" table. The result should include the month-year and the corresponding total donation amount. Ensure that the query handles cases where no donations were made in a specific month-year.
Select
      D.DonationDate,
      Sum(D.DonationAmount) as TotalDonationAmount
From Donations as D
Group by Year(D.DonationDate),month(D.DonationDate)
Order by Year(D.DonationDate),month(D.DonationDate)

--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
Select Distinct Breed
From Pets
Where (Age Between 1 and 3) or Age > 5

--12.Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.
Select P.Name, P.Age,P.Breed,P.Type,S.Name,S.Location
From Pets as P
join Shelters as S on P.ShelterID=S.ShelterID
Where P.AvailableForAdoption=1

--13.Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai
Select Count(P.ParticipantID) as TotalParticipants 
From Participants as P
Join
AdoptionEvents as Ae on P.EventID=Ae.EventID
Join
Shelters as S on Ae.ShelterID=S.ShelterID
Where S.Location Like 'Walk Street'

--14.Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
Select Distinct Breed
From Pets
Where Age Between 1 and 5

--15.Find the pets that have not been adopted by selecting their information from the 'Pet' table.
Select Name,Age,Breed,Type
From Pets
where OwnerID is NUll

--16.Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
Select P.Name ,A.AdopterID
From Pets as P
Join
Adoptions as A on P.PetID=A.PetID


--17.Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.
Select 
       S.Name, S.Location ,
       Count(P.PetID) as AvailablePetsCount
from Shelters as S
Left join
Pets as P on S.ShelterID=P.ShelterID And P.AvailableForAdoption=1
Group by S.ShelterID,S.Name,S.Location
Order by S.Name

--18.Find pairs of pets from the same shelter that have the same breed.
Select P1.Name,
P2.Name,
P1.Breed
from Pets as P1
join Pets as P2 on P1.ShelterID=P2.ShelterID
And P1.Breed=P2.Breed

--19. List all possible combinations of shelters and adoption events.
Select S.Name ,
Ae.EventName
From Shelters as s
Cross Join AdoptionEvents as Ae
Order by S.Name,Ae.EventName

--20. Determine the shelter that has the highest number of adopted pets.
Select Top 1
       S.Name,
       S.Location,
	   Count(P.PetID) as AdoptedPetsCount
From Shelters as S
Join Pets as P on S.ShelterID=P.ShelterID
Where P.OwnerID is Not null
Group by S.ShelterID,S.Name,S.Location
Order by AdoptedPetsCount
