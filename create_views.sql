create view ClientsWithPersonData
as
	select c.Id,p.BirthDate,p.Name from Clients c
	inner join People p
	on p.Id = c.PersonId;

GO

create view EmployeesWithPersonData
as
	select e.Id,p.BirthDate,p.Name,e.DepartmentId from Employees e
	inner join People p
	on p.Id = e.PersonId;
