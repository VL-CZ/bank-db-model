create table [dbo].[CommonData](
	[YearlyInterestRate] [decimal] not null,
	[LoanInterestRate] [decimal] not null,
);

create table [dbo].[People](
	[Id] [int] identity(1,1) not null primary key,
	[Name] [nvarchar](200) not null,
	[BirthDate] [date] not null,
);

create table [dbo].[Departments](
	[Id] [int] identity(1,1) not null primary key,
	[Address] [nvarchar](max) not null
);

create table [dbo].[Employees](
	[Id] [int] not null primary key,
	[DepartmentId] [int] not null, 
	constraint [FK_Employee_Department] foreign key([DepartmentId])
		references [dbo].[Departments] ([Id]),
	constraint [FK_Employee_Person] foreign key([Id])
		references [dbo].[People] ([Id])
);

create table [dbo].[Clients](
	[Id] [int] not null primary key,
	[IsActive] [bit] not null default 1,
	constraint [FK_Client_Person] foreign key([Id])
		references [dbo].[People] ([Id])
);

create table [dbo].[Loans](
	[Id] [int] identity(1,1) not null primary key,
	[AmountLoaned] [decimal] not null,
	[TotalAmountToPay] [decimal] not null,
	[RemainingAmount] [decimal] not null,
	[ClientId] [int] not null,
	[MonthlyPayment] [decimal] not null,
	[IsCompleted] [bit] not null default 0,
	constraint [FK_Loans_Clients] foreign key([ClientId])
		references [dbo].[Clients] ([Id])
);

create table [dbo].[Accounts](
	[Id] [int] identity(1,1) not null primary key,
	[Balance] [decimal] not null,
	[Number] [nvarchar](12) not null unique,
	[OwnerId] [int] not null,
	[IsSaving] [bit] not null,
	[IsActive] [bit] not null default 1,
	constraint [FK_Accounts_Clients] foreign key([OwnerId])
		references [dbo].[Clients] ([Id])
);

create table [dbo].[PaymentCards](
	[Id] [int] identity(1,1) not null primary key,
	[Number] [nvarchar](16) not null unique,
	[PinHash] [nvarchar](200) not null default 'xxWEVSDAEewdv23faD23t4wes',
	[ExpirationDate] [date] not null,
	[SecurityCode] [int] not null,
	[AccountId] [int] not null,
	constraint [FK_PaymentCards_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id])
);

create table [dbo].[MoneyTransactions](
	[Id] [int] identity(1,1) not null primary key,
	[DateCreated] [date] not null,
	[Amount] [decimal] not null
);

create table [dbo].[LoanPayments](
	[Id] [int] not null primary key,
	[AccountId] [int] not null,
	[LoanId] [int] not null,
	constraint [FK_LoanPayments_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_LoanPayments_Loans] foreign key([LoanId])
		references [dbo].[Loans] ([Id]),
	constraint [FK_LoanPayments_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);

create table [dbo].[YearlyInterestTransactions](
	[Id] [int] not null primary key,
	[AccountId] [int] not null,
	constraint [FK_YearlyInterestTransactions_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_YearlyInterestTransactions_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);

create table [dbo].[MoneyWithdrawals](
	[Id] [int] not null primary key,
	[AccountId] [int] not null,
	constraint [FK_MoneyWithdrawals_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_MoneyWithdrawals_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);

create table [dbo].[MoneyDeposits](
	[Id] [int] not null primary key,
	[AccountId] [int] not null,
	constraint [FK_MoneyDeposits_Accounts] foreign key([AccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_MoneyDeposits_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id])
);

create table [dbo].[MoneyTransfers](
	[Id] [int] not null primary key,
	[SenderAccountId] [int] not null,
	[RecipientAccountId] [int] not null,
	constraint [FK_MoneyTransfers_MoneyTransactions] foreign key([Id])
		references [dbo].[MoneyTransactions] ([Id]),
	constraint [FK_Payment_Accounts] foreign key([SenderAccountId])
		references [dbo].[Accounts] ([Id]),
	constraint [FK_Payment_Accounts1] foreign key([RecipientAccountId])
		references [dbo].[Accounts] ([Id])
);
