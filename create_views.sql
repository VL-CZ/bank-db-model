-- get all Clients with their personal data
create view ClientsWithPersonData
as
	select c.Id,p.BirthDate,p.Name 
	from Clients c
	inner join People p
	on p.Id = c.PersonId;

go

-- get all Employees with their personal data
create view EmployeesWithPersonData
as
	select e.Id,p.BirthDate,p.Name,e.DepartmentId 
	from Employees e
	inner join People p
	on p.Id = e.PersonId;

go

-- get all Accounts including their owners
create view AccountsWithOwners
as
	select p.Id, p.Name, p.BirthDate, a.Number, a.Balance
	from Accounts a
	inner join Clients c on c.Id = a.OwnerId
	inner join People p on p.Id = c.PersonId

go

-- get all loans with their owners
create view ActiveLoansWithOwners
as
	select p.Id, p.Name, p.BirthDate,l.TotalAmount, l.RemainingAmount
	from Loans l
	inner join Clients c on c.Id = l.ClientId
	inner join People p on p.Id = c.PersonId
	where l.IsCompleted = 0

go
