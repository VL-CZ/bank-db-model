insert into Departments(Address,CountryCode)
values
('Old Town Square 25, Prague','CZ'),
('New St. 1220, Brno','CZ');

insert into People(Name,BirthDate)
values
('John Doe','1990-02-15'),
('Thomas Johnson','1999-11-26'),
('Emma Johnson','1970-04-12'),
('Oliver Jones','1931-07-09'),
('Jacob Smith','1964-04-06'),
('Michael Brown','1978-12-24');

insert into Employees(Id,DepartmentId)
values
(1,1),
(4,2),
(5,1);

insert into Clients(Id)
values
(2),
(3),
(4),
(6);

insert into Loans(TotalAmount,RemainingAmount,ClientId,MonthlyPayment,IsCompleted)
values
(100000,50000,2,5000,0),
(25000,5000,3,1000,0);

insert into Accounts(Balance,Number,OwnerId)
values
(500000,'1112223334',2),
(100000,'1234567890',3),
(1234567,'9876543210',4),
(550,'1231231231',6);

insert into PaymentCards(Number,ExpirationDate,SecurityCode,AccountId)
values
('1234567890','2022-08-25',123,1),
('2225554444','2022-04-30',123,2),
('1111122222','2022-12-31',123,3);
