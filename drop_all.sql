-- drop all procedures
drop procedure TryRemovePerson;
drop procedure AddEmployeeToDepartment;
drop procedure RemoveEmployee;
drop procedure AddClient;
drop procedure RemoveClient;
drop procedure AddStandardAccount;
drop procedure AddSavingAccount;
drop procedure RemoveAccount;
drop procedure AddLoan;
drop procedure AddCard;
drop procedure RemoveCard;
drop procedure GetActiveLoansOf;
drop procedure TotalMonthlyPaymentOf;
drop procedure TransferMoney;
drop procedure WithdrawMoney;
drop procedure DepositMoney;
drop procedure MarkCompletedLoans;
drop procedure PayMonthlyLoan;
drop procedure AddYearlyInterest;
drop procedure AddInterestsToSavingAccounts;
drop procedure GetAllIncomingTransactions
drop procedure GetAllOutcomingTransactions;

-- drop all views
drop view ClientsWithPersonData;
drop view EmployeesWithPersonData;
drop view AccountsWithOwners;
drop view ActiveLoansWithOwners;
drop view AllTransactions;

-- drop all tables
drop table [dbo].[MoneyTransfers];
drop table [dbo].[MoneyDeposits];
drop table [dbo].[MoneyWithdrawals];
drop table [dbo].[YearlyInterestTransactions];
drop table [dbo].[LoanPayments];
drop table [dbo].[MoneyTransactions];
drop table [dbo].[PaymentCards];
drop table [dbo].[Accounts];
drop table [dbo].[Loans];
drop table [dbo].[Clients];
drop table [dbo].[Employees];
drop table [dbo].[Departments];
drop table [dbo].[People];
drop table [dbo].[CommonData];
