CREATE TABLE [dbo].[CommonData](
	[YearlyInterestRate] [float] NOT NULL
);

CREATE TABLE [dbo].[People](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](200) NOT NULL,
	[BirthDate] [date] NOT NULL,
);

CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Address] [nvarchar](max) NOT NULL
);

CREATE TABLE [dbo].[Employees](
	[Id] [int] NOT NULL PRIMARY KEY,
	[DepartmentId] [int] NOT NULL, 
	CONSTRAINT [FK_Employee_Department] FOREIGN KEY([DepartmentId])
		REFERENCES [dbo].[Departments] ([Id]),
	CONSTRAINT [FK_Employee_Person] FOREIGN KEY([Id])
		REFERENCES [dbo].[People] ([Id])
);

CREATE TABLE [dbo].[Clients](
	[Id] [int] NOT NULL PRIMARY KEY,
	CONSTRAINT [FK_Client_Person] FOREIGN KEY([Id])
		REFERENCES [dbo].[People] ([Id])
);

CREATE TABLE [dbo].[Loans](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[TotalAmount] [int] NOT NULL,
	[RemainingAmount] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
	[MonthlyPayment] [int] NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	CONSTRAINT [FK_Loans_Clients] FOREIGN KEY([ClientId])
		REFERENCES [dbo].[Clients] ([Id])
);

CREATE TABLE [dbo].[Accounts](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Balance] [int] NOT NULL,
	[Number] [nvarchar](20) NOT NULL UNIQUE,
	[OwnerId] [int] NOT NULL,
	[IsSaving] [bit] NOT NULL,
	CONSTRAINT [FK_Accounts_Clients] FOREIGN KEY([OwnerId])
		REFERENCES [dbo].[Clients] ([Id])
);

CREATE TABLE [dbo].[PaymentCards](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Number] [nchar](10) NOT NULL UNIQUE,
	[ExpirationDate] [date] NOT NULL,
	[SecurityCode] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	CONSTRAINT [FK_PaymentCards_Accounts] FOREIGN KEY([AccountId])
		REFERENCES [dbo].[Accounts] ([Id])
);

CREATE TABLE [dbo].[MoneyTransactions](
	[Id] [int] NOT NULL PRIMARY KEY,
	[DateCreated] [date] NOT NULL,
	[Amount] [int] NOT NULL
);

CREATE TABLE [dbo].[LoanPayments](
	[Id] [int] NOT NULL PRIMARY KEY,
	[AccountId] [int] NOT NULL,
	[LoanId] [int] NOT NULL,
	CONSTRAINT [FK_LoanPayments_Accounts] FOREIGN KEY([AccountId])
		REFERENCES [dbo].[Accounts] ([Id]),
	CONSTRAINT [FK_LoanPayments_Loans] FOREIGN KEY([LoanId])
		REFERENCES [dbo].[Loans] ([Id]),
	CONSTRAINT [FK_LoanPayments_MoneyTransactions] FOREIGN KEY([Id])
		REFERENCES [dbo].[MoneyTransactions] ([Id])
);

CREATE TABLE [dbo].[YearlyInterestTransactions](
	[Id] [int] NOT NULL PRIMARY KEY,
	[AccountId] [int] NOT NULL,
	CONSTRAINT [FK_YearlyInterestTransactions_Accounts] FOREIGN KEY([AccountId])
		REFERENCES [dbo].[Accounts] ([Id]),
	CONSTRAINT [FK_YearlyInterestTransactions_MoneyTransactions] FOREIGN KEY([Id])
		REFERENCES [dbo].[MoneyTransactions] ([Id])
);

CREATE TABLE [dbo].[MoneyWithdrawals](
	[Id] [int] NOT NULL PRIMARY KEY,
	[AccountId] [int] NOT NULL,
	CONSTRAINT [FK_MoneyWithdrawals_Accounts] FOREIGN KEY([AccountId])
		REFERENCES [dbo].[Accounts] ([Id]),
	CONSTRAINT [FK_MoneyWithdrawals_MoneyTransactions] FOREIGN KEY([Id])
		REFERENCES [dbo].[MoneyTransactions] ([Id])
);

CREATE TABLE [dbo].[MoneyDeposits](
	[Id] [int] NOT NULL PRIMARY KEY,
	[AccountId] [int] NOT NULL,
	CONSTRAINT [FK_MoneyDeposits_Accounts] FOREIGN KEY([AccountId])
		REFERENCES [dbo].[Accounts] ([Id]),
	CONSTRAINT [FK_MoneyDeposits_MoneyTransactions] FOREIGN KEY([Id])
		REFERENCES [dbo].[MoneyTransactions] ([Id])
);

CREATE TABLE [dbo].[MoneyTransfers](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SenderAccountId] [int] NOT NULL,
	[RecipientAccountId] [int] NOT NULL,
	CONSTRAINT [FK_MoneyTransfers_MoneyTransactions] FOREIGN KEY([Id])
		REFERENCES [dbo].[MoneyTransactions] ([Id]),
	CONSTRAINT [FK_Payment_Accounts] FOREIGN KEY([SenderAccountId])
		REFERENCES [dbo].[Accounts] ([Id]),
	CONSTRAINT [FK_Payment_Accounts1] FOREIGN KEY([RecipientAccountId])
		REFERENCES [dbo].[Accounts] ([Id])
);
