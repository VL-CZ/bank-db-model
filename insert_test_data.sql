insert into CommonData(YearlyInterestRate)
values (0,01);

insert into Departments(Address)
values
('Old Town Square 25, Prague, Czech Republic'),
('New St. 1220, Brno, Czech Republic');

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
(100000,120000,2,5000,0),
(20000,24000,3,1000,0);

-- default data (no money)
insert into Accounts(Balance,Number,OwnerId,IsSaving)
values
(0,'1112223334',2,0),
(0,'1234567890',3,1),
(0,'9876543210',4,0),
(0,'9996663330',4,1),
(0,'1231231231',6,0);

insert into PaymentCards(Number,ExpirationDate,SecurityCode,AccountId)
values
('1234567890','2022-08-25',123,1),
('2225554444','2022-04-30',123,3),
('1111122222','2022-12-31',123,5);

-- deposit money to accounts
exec DepositMoney 1,5000;
exec DepositMoney 2,10000;
exec DepositMoney 3,100000;
exec DepositMoney 4,999999;
exec DepositMoney 5,250000;
exec DepositMoney 3,50000;

-- add yearly interests to all saving accounts
exec AddYearlyInterests;
