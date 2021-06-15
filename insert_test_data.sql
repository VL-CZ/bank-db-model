insert into CommonData(YearlyInterestRate,LoanInterestRate)
values (0.01,0.1);

insert into Departments(Address)
values
('Department 1'),
('Department 2');

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

insert into Loans(AmountLoaned,TotalAmountToPay,RemainingAmount,ClientId,MonthlyPayment,IsCompleted)
values
(100000,110000,110000,2,5000,0),
(20000,22000,22000,3,1000,0);

-- default data (no money)
insert into Accounts(Balance,Number,OwnerId,IsSaving)
values
(0,'001112223334',2,0),
(0,'001234567890',3,1),
(0,'009876543210',4,0),
(0,'009996663330',4,1),
(0,'001231231231',6,0);

insert into PaymentCards(Number,ExpirationDate,SecurityCode,AccountId)
values
('1234567890000000','2022-08-25',123,1),
('2222555544443333','2022-04-30',123,3),
('1111222233334444','2022-12-31',123,5);

