-- gets all account of the given client
create procedure GetAccountsOf
	@idClient int -- identifier of the client
as
	select a.Id, a.Number, a.Balance
	from Accounts a
	inner join Clients c on a.OwnerId = c.Id
	where c.Id = @idClient;

go

-- try to remove person by its id
-- if it's related to any client or employee -> do nothing
-- otherwise delete the row
create procedure TryRemovePerson
	@idPerson int -- identifier of the person to remove
as
	declare @canDelete bit;
	set @canDelete = 1;

	if exists (
		select top 1 * 
		from Employees e 
		where e.PersonId = @idPerson
	)
	begin
		set @canDelete = 0
	end;

	if exists (
		select top 1 * 
		from Clients c
		where c.PersonId = @idPerson
	)
	begin
		set @canDelete = 0
	end;

	if(@canDelete = 1)
	begin
		delete from People
		where Id = @idPerson
	end;
go

-- add new employee to existing deparment
create procedure AddEmployeeToDepartment
	@name nvarchar(100), -- employee name
	@birthDate date, -- birth date of the employee
	@departmentId int -- id of the department where to add
as
	insert into People(Name,BirthDate)
	values (@name,@birthDate);

	insert into Employees(PersonId,DepartmentId)
	values (SCOPE_IDENTITY(),@departmentId);

go

-- remove employee by its id
create procedure RemoveEmployee
	@idEmployee int -- id of the employee to remove
as
	declare @idPerson int;

	select 
		@idPerson = e.PersonId
	from Employees e
	where e.Id = @idEmployee;

	delete from Employees
	where Id = @idEmployee;

	exec TryRemovePerson @idPerson;

go

-- add new client
create procedure AddClient
	@name nvarchar(100), -- name of the client
	@birthDate date -- birth date of the client
as
	insert into People(Name,BirthDate)
	values (@name,@birthDate);

	insert into Clients(PersonId)
	values (SCOPE_IDENTITY());

go

-- remove client by its id
create procedure RemoveClient
	@idClient int -- id of the client to remove
as
	declare @idPerson int;

	select 
		@idPerson = c.PersonId
	from Clients c
	where c.Id = @idClient;

	delete from Clients
	where Id = @idClient

	exec TryRemovePerson @idPerson;

go

-- add new account
create procedure AddAccount
	@number int, -- account number
	@idClient int -- id of the owner
as
	insert into Accounts(Number,Balance,OwnerId)
	values (@number,0,@idClient);

go

-- remove account by its id 
create procedure RemoveAccount
	@idAccount int -- id of the account to remove
as
	delete from PaymentCards
	where AccountId = @idAccount;

	delete from Accounts
	where Id = @idAccount;

go

-- add new loan to client
-- send money to the given account
-- and create new loan entity
create procedure AddLoan
	@idAccount int, -- account where to send money
	@amount int -- amount of money
as
	declare @idClient int;

	update Accounts
	set Balance = Balance + @amount
	where Id = @idAccount;

	select
		@idClient = a.OwnerId
	from Accounts a
	where a.Id = @idAccount;

	insert into Loans(ClientId,TotalAmount,RemainingAmount)
	values(@idClient,@amount,@amount * 1.2);

go

-- add new card
create procedure AddCard
	@idAccount int, -- id of the account that this card belongs to
	@number nchar(10), -- card number
	@expirationDate date, -- expiration date
	@securityCode int -- security code
as
	insert into PaymentCards(AccountId,ExpirationDate,Number,SecurityCode)
	values (@idAccount,@expirationDate,@number,@securityCode);

go

-- remove payment card
create procedure RemoveCard
	@idCard int -- id of the card to remove
as
	delete from PaymentCards
	where Id = @idCard;

go

-- get all active loans of the given client
create procedure GetActiveLoansOf
	@idClient int -- identifier of the client
as
	select l.TotalAmount, l.RemainingAmount,l.MonthlyPayment
	from Loans l
	where l.IsCompleted = 0 and l.ClientId = @idClient;

go

-- get total monthly payment for all of the client's loans
create procedure TotalMonthlyPaymentOf
	@idClient int -- identifier of the client
as
	select sum(l.MonthlyPayment)
	from Loans l
	where l.IsCompleted = 0 and l.ClientId = @idClient;

go

-- transfer money from one account to another
create procedure TransferMoney
	@senderAccountId int, -- account id of the sender
	@recipientAccountId int, -- account id of the recipient
	@amount int -- amount of money sent
as
	update Accounts
	set Balance = Balance - @amount
	where Id = @senderAccountId;

	update Accounts
	set Balance = Balance + @amount
	where Id = @recipientAccountId;

	insert into Payments(SenderAccountId, RecipientAccountId, Amount, CreatedAt)
	values (@senderAccountId, @recipientAccountId, @amount, GETDATE());
go

-- get all incoming payments to the given recipient
create procedure GetAllIncomingPayments
	@idAccount int -- id of the recipient account
as
	select a.Number as 'Sender', p.Amount, p.CreatedAt as 'Date' 
	from Accounts a
	inner join Payments p
	on p.SenderAccountId = a.Id
	where p.recipientAccountId = @idAccount;

go

-- get all outcoming payments from the given sender
create procedure GetAllOutcomingPayments
	@idAccount int -- id of the sender account
as
	select a.Number as 'Sender', p.Amount, p.CreatedAt as 'Date' 
	from Accounts a
	inner join Payments p
	on p.RecipientAccountId = a.Id
	where p.SenderAccountId = @idAccount;

go
