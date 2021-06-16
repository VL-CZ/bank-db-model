-- this table contains a single row with common data
create table [dbo].[CommonData](
	[YearlyInterestRate] [money] not null, -- interest that is added yearly to saving accounts
	[LoanInterestRate] [money] not null, -- interest that is added to loan (e.g. if it's 0.1, then the client must pay 110% of the loaned amount)
);

-- this table represents Person entity
create table [dbo].[People](
	[Id] [int] identity(1,1) not null primary key,
	[Name] [nvarchar](200) not null, -- name of the person
	[BirthDate] [date] not null, -- birth date of the person
);

-- this table represents bank department
create table [dbo].[Departments](
	[Id] [int] identity(1,1) not null primary key,
	[Name] [nvarchar](max) not null -- name of the department
);

-- Employee entity
-- this entity extends Person entity
create table [dbo].[Employees](
	[Id] [int] not null primary key, -- Id of the corresponding Person entity (contains name and birthDate)
	[DepartmentId] [int] not null, -- id of the department that this employee belongs to
	constraint [FK_Employee_Department] foreign key([DepartmentId])
		references [dbo].[Departments] ([Id]),
	constraint [FK_Employee_Person] foreign key([Id])
		references [dbo].[People] ([Id])
);
create index Employees_DeparmentId on Employees(DepartmentId);

-- represents a Client = person who has account/loan in the bank
create table [dbo].[Clients](
	[Id] [int] not null primary key, -- Id of the corresponding Person entity (contains name and birthDate)
	[IsActive] [bit] not null default 1, -- is this client still active? (we don't delete entities in order to preserve transaction history)
	constraint [FK_Client_Person] foreign key([Id])
		references [dbo].[People] ([Id])
);

-- loan entity
create table [dbo].[Loans](
	[Id] [int] identity(1,1) not null primary key,
	[AmountLoaned] [money] not null, -- total amount loaned by the client
	[TotalAmountToPay] [money] not null, -- total amount to pay (AmountLoaned * (1+InterestRate)) 
	[RemainingAmount] [money] not null, -- remaining amount to pay
	[ClientId] [int] not null,
	[MonthlyPayment] [money] not null, -- amount of monthly payment
	[IsCompleted] [bit] not null default 0, -- is this loand completed? (e.g. is RemainingAmount = 0 ?)
	constraint [FK_Loans_Clients] foreign key([ClientId])
		references [dbo].[Clients] ([Id])
);
create index Loans_ClientId on Loans(ClientId);

-- this table contains clients' accounts
create table [dbo].[Accounts](
	[Id] [int] identity(1,1) not null primary key,
	[Balance] [money] not null, -- current balance on the account
	[Number] [nvarchar](12) not null unique, -- number of the account
	[OwnerId] [int] not null,
	[IsSaving] [bit] not null, -- is this account standard or saving account? (0 -> standard, 1 -> saving)
	[IsActive] [bit] not null default 1, -- is this account still active?
	constraint [FK_Accounts_Clients] foreign key([OwnerId])
		references [dbo].[Clients] ([Id])
);
create index Accounts_OwnerId on Accounts(OwnerId);

-- represents payment cards
create table [dbo].[PaymentCards](
	[Id] [int] identity(1,1) not null primary key,
	[Number] [nvarchar](16) not null unique, -- card number
	[PinHash] [nvarchar](200) not null default 'xxWEVSDAEewdv23faD23t4wes', -- hash of the card's PIN (we use default value for simplicity)
	[ExpirationDate] [date] not null,
	[SecurityCode] [int] not null,
	[AccountId] [int] not null, -- id of the account that this card belongs to
	constraint [FK_PaymentCards_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id])
);
create index PaymentCards_AccountId on PaymentCards(AccountId);

-- this is a base table for all money transactions (money transfers, withdrawals, deposits,...)
create table [dbo].[MoneyTransactions](
	[Id] [int] identity(1,1) not null primary key,
	[DateCreated] [date] not null,
	[Amount] [money] not null -- amount of money
);

-- this table contains all monthly loan payment records
create table [dbo].[LoanPayments](
	[Id] [int] not null primary key, -- identifier of the corresponding MoneyTransaction entity
	[AccountId] [int] not null, -- id of the client that paid the amount
	[LoanId] [int] not null, -- id of the loan that we pay
	constraint [FK_LoanPayments_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_LoanPayments_Loans] foreign key([LoanId])
		references [dbo].[Loans] ([Id]),
	constraint [FK_LoanPayments_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);
create index LoanPayments_AccountId on LoanPayments(AccountId);
create index LoanPayments_LoanId on LoanPayments(LoanId);

-- this table contains all yearly interest transactions
-- yearly interest is added only to saving accounts
create table [dbo].[YearlyInterestTransactions](
	[Id] [int] not null primary key, -- identifier of the corresponding MoneyTransaction entity
	[AccountId] [int] not null, -- id of the account that the money is sent to
	constraint [FK_YearlyInterestTransactions_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_YearlyInterestTransactions_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);
create index YearlyInterestTransactions_AccountId on YearlyInterestTransactions(AccountId);

-- this table contains all records of Money withdrawals
create table [dbo].[MoneyWithdrawals](
	[Id] [int] not null primary key, -- identifier of the corresponding MoneyTransaction entity
	[AccountId] [int] not null, -- id of the account that we withdraw money from
	constraint [FK_MoneyWithdrawals_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_MoneyWithdrawals_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);
create index MoneyWithdrawals_AccountId on MoneyWithdrawals(AccountId);

-- this table contains all records of Money deposits
create table [dbo].[MoneyDeposits](
	[Id] [int] not null primary key, -- identifier of the corresponding MoneyTransaction entity
	[AccountId] [int] not null, -- id of the account that we deposit money to
	constraint [FK_MoneyDeposits_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_MoneyDeposits_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);
create index MoneyDeposits_AccountId on MoneyDeposits(AccountId);

-- this table contains records of all money transfers betweeen two accounts
create table [dbo].[MoneyTransfers](
	[Id] [int] not null primary key, -- identifier of the corresponding MoneyTransaction entity
	[SenderAccountId] [int] not null, -- id of the sender account
	[RecipientAccountId] [int] not null, -- id of the recipient account
	constraint [FK_MoneyTransfers_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id]),
	constraint [FK_Payment_Accounts] foreign key([SenderAccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_Payment_Accounts1] foreign key([RecipientAccountId])
		references [dbo].[Accounts] ([Id])
);
create index MoneyTransfers_SenderAccountId on MoneyTransfers(SenderAccountId);
create index MoneyTransfers_RecipientAccountId on MoneyTransfers(RecipientAccountId);
