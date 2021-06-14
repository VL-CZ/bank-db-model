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
		where e.Id = @idPerson
	)
	begin
		set @canDelete = 0;
	end

	if exists (
		select top 1 * 
		from Clients c
		where c.Id = @idPerson
	)
	begin
		set @canDelete = 0;
	end

	if(@canDelete = 1)
	begin
		delete from People
		where Id = @idPerson;
	end
go

-- add new employee to existing deparment
create procedure AddEmployeeToDepartment
	@name nvarchar(100), -- employee name
	@birthDate date, -- birth date of the employee
	@departmentId int -- id of the department where to add
as
	insert into People(Name,BirthDate)
	values (@name,@birthDate);

	insert into Employees(Id,DepartmentId)
	values (SCOPE_IDENTITY(),@departmentId);

go

-- remove employee by its id
create procedure RemoveEmployee
	@idEmployee int -- id of the employee to remove
as
	delete from Employees
	where Id = @idEmployee;

	exec TryRemovePerson @idEmployee;

go

-- add new client
create procedure AddClient
	@name nvarchar(100), -- name of the client
	@birthDate date -- birth date of the client
as
	insert into People(Name,BirthDate)
	values (@name,@birthDate);

	insert into Clients(Id)
	values (SCOPE_IDENTITY());

go

-- remove client by its id
create procedure RemoveClient
	@idClient int -- id of the client to remove
as
	delete from Clients
	where Id = @idClient

	exec TryRemovePerson @idClient;

go

-- add new standard account
create procedure AddStandardAccount
	@number int, -- account number
	@idClient int -- id of the owner
as
	insert into Accounts(Number,Balance,OwnerId,IsSaving)
	values (@number,0,@idClient,0);

go

-- add new saving account
create procedure AddSavingAccount
	@number int, -- account number
	@idClient int -- id of the owner
as
	insert into Accounts(Number,Balance,OwnerId,IsSaving)
	values (@number,0,@idClient,1);

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

	insert into MoneyTransactions(Amount, DateCreated)
	values (@amount, GETDATE());

	insert into MoneyTransfers(Id, SenderAccountId, RecipientAccountId)
	values (SCOPE_IDENTITY(),@senderAccountId, @recipientAccountId);
go

-- withdraw money from the selected account
create procedure WithdrawMoney
	@idAccount int, -- id of the account
	@amount int -- amount to withdraw
as
	update Accounts
	set Balance = Balance - @amount
	where Id = @idAccount;

	insert into MoneyTransactions(Amount, DateCreated)
	values (@amount, GETDATE());

	insert into MoneyWithdrawals(Id,AccountId)
	values (SCOPE_IDENTITY(),@idAccount);
go

-- deposit money to the given account
create procedure DepositMoney
	@idAccount int, -- id of the account
	@amount int -- amount to deposit
as
	update Accounts
	set Balance = Balance + @amount
	where Id = @idAccount;

	insert into MoneyTransactions(Amount, DateCreated)
	values (@amount, GETDATE());

	insert into MoneyDeposits(Id,AccountId)
	values (SCOPE_IDENTITY(),@idAccount);
go

-- mark loans that are completely paid
create procedure MarkCompletedLoans
as
	update Loans
	set IsCompleted = 1
	where RemainingAmount <= 0;

go

-- pay monthly loan fee
create procedure PayMonthlyLoan
	@idAccount int, -- identifier of the account
	@idLoan int -- id of the loan to pay
as
	declare @amount int;

	select
		@amount = case 
		when l.MonthlyPayment <= l.RemainingAmount 
			then l.MonthlyPayment
			else l.RemainingAmount
		end
	from Loans l
	where l.Id = @idLoan;

	update Accounts
	set Balance = Balance - @amount
	where Id = @idAccount;

	insert into MoneyTransactions(Amount, DateCreated)
	values (@amount, GETDATE());

	insert into LoanPayments(Id,AccountId,LoanId)
	values (SCOPE_IDENTITY(),@idAccount,@idLoan);
go

-- add yearly interest to the selected account
create procedure AddYearlyInterest
	@idAccount int -- id of the account where to add money
as
	declare @yearlyInterestRate int;
	declare @moneyToAdd int;

	select
		@yearlyInterestRate = c.YearlyInterestRate
	from CommonData c;
	
	select
		@moneyToAdd = a.Balance * @yearlyInterestRate
	from Accounts a
	where a.Id = @idAccount;

	update Accounts
	set Balance = Balance + @moneyToAdd
	where Id = @idAccount;

	insert into MoneyTransactions(Amount, DateCreated)
	values (@moneyToAdd, GETDATE());

	insert into YearlyInterestTransactions(Id,AccountId)
	values (SCOPE_IDENTITY(),@idAccount);
go

-- add yearly interests to all saving accounts
create procedure AddInterestsToSavingAccounts
as
	declare @accountCursor cursor;
	declare @idAccount int;

	set @accountCursor = cursor for
		select a.Id
		from Accounts a
		where a.IsSaving=1;

	open @accountCursor;
	fetch next
	from @accountCursor into @idAccount;
	while @@FETCH_STATUS = 0
	begin
		exec AddYearlyInterest @idAccount;
		fetch next
		from @accountCursor into @idAccount;
	end

	close @accountCursor;
	deallocate @accountCursor;

go

-- get all incoming payments to the given recipient
create procedure GetAllIncomingTransactions
	@idAccount int -- id of the recipient account
as
	select * from AllTransactions
	where TargetAccountId = @idAccount;
go

-- get all outcoming payments from the given sender
create procedure GetAllOutcomingTransactions
	@idAccount int -- id of the sender account
as
	select * from AllTransactions
	where SourceAccountId = @idAccount;
go