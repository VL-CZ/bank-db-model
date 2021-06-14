-- get all Clients with their personal data
create view ClientsWithPersonData
as
	select p.Id,p.BirthDate,p.Name 
	from Clients c
	inner join People p
	on p.Id = c.Id;

go

-- get all Employees with their personal data
create view EmployeesWithPersonData
as
	select p.Id,p.BirthDate,p.Name,e.DepartmentId 
	from Employees e
	inner join People p
	on p.Id = e.Id;

go

-- get all Accounts including their owners
create view AccountsWithOwners
as
	select p.Id, p.Name, p.BirthDate, a.Number, a.Balance, a.IsSaving
	from Accounts a
	inner join Clients c on c.Id = a.OwnerId
	inner join People p on p.Id = c.Id

go

-- get all loans with their owners
create view ActiveLoansWithOwners
as
	select p.Id, p.Name, p.BirthDate,l.TotalAmount, l.RemainingAmount
	from Loans l
	inner join Clients c on c.Id = l.ClientId
	inner join People p on p.Id = c.Id
	where l.IsCompleted = 0

go

-- get all transactions
create view AllTransactions
as
	select senders.Number as 'SourceAccount', recipients.Number as 'TargetAccount', mts.Amount, mts.DateCreated as 'Date', 
		mts.Id as 'TransactionId', senders.Id as 'SourceAccountId', recipients.Id as 'TargetAccountId'
	from Accounts senders
	inner join MoneyTransfers mtf
	on mtf.SenderAccountId = senders.Id
	inner join MoneyTransactions mts
	on mtf.Id = mts.Id
	inner join Accounts recipients
	on mtf.RecipientAccountId = recipients.Id

	union

	select 'Deposit' as 'SourceAccount', a.Number as 'TargetAccount', mts.Amount, mts.DateCreated as 'Date',
		mts.Id as 'TransactionId', null as 'SourceAccountId', a.Id as 'TargetAccountId'
	from MoneyDeposits md
	inner join MoneyTransactions mts
	on mts.Id = md.Id
	inner join Accounts a
	on a.Id = md.AccountId

	union

	select 'Yearly interest' as 'SourceAccount', a.Number as 'TargetAccount', mts.Amount, mts.DateCreated as 'Date',
		mts.Id as 'TransactionId', null as 'SourceAccountId', a.Id as 'TargetAccountId'
	from YearlyInterestTransactions yit
	inner join MoneyTransactions mts
	on mts.Id = yit.Id
	inner join Accounts a
	on a.Id = yit.AccountId

	union

	select a.Number as 'SourceAccount', 'Withdrawal' as 'TargetAccount', mts.Amount, mts.DateCreated as 'Date',
		mts.Id as 'TransactionId', a.Id as 'SourceAccountId', null as 'TargetAccountId'
	from MoneyWithdrawals mw
	inner join MoneyTransactions mts
	on mts.Id = mw.Id
	inner join Accounts a
	on a.Id = mw.AccountId

	union

	select a.Number as 'SourceAccount', 'Loan payment' as 'TargetAccount', mts.Amount, mts.DateCreated as 'Date',
		mts.Id as 'TransactionId', a.Id as 'SourceAccountId', null as 'TargetAccountId'
	from LoanPayments lp
	inner join MoneyTransactions mts
	on mts.Id = lp.Id
	inner join Accounts a
	on a.Id = lp.Id
go