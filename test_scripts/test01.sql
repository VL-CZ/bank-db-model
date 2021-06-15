-- this scripts test mostly stored procedures that add/remove entities

select * from ClientsWithPersonData;

-- add new client
exec AddClient 'Tomas Svoboda','1990-12-31';
select * from ClientsWithPersonData;

select * from AccountsWithOwners;

-- add new accounts
exec AddStandardAccount '1591591590',7;
exec AddSavingAccount '1591591591',7;
select * from AccountsWithOwners;

-- add new card
exec AddCard 6,'1987462532','2022-08-25',123;

select * from PaymentCards pc
where pc.AccountId=6;

-- remove the card
exec RemoveCard 4;

select * from PaymentCards pc
where pc.AccountId=6;

select * from PaymentCards;
-- try to add card to saving account -> throws error
exec AddCard 4,'1987462599','2022-08-25',123;
select * from PaymentCards;

select * from AccountsWithOwners;

-- remove the accounts
exec RemoveAccount 6;
exec RemoveAccount 7;

select * from AccountsWithOwners;
select * from ClientsWithPersonData;

-- remove the client
exec RemoveClient 7;
select * from ClientsWithPersonData;

-- EMPLOYEES

select * from EmployeesWithPersonData;

-- add new employee
exec AddEmployee 'Jan Novak','2000-01-01',1;
select * from EmployeesWithPersonData;

-- remove it
exec RemoveEmployee 1;
select * from EmployeesWithPersonData;
