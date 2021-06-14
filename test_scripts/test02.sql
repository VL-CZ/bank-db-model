-- this script tests mainly operations with money

select * from AccountsWithOwners;

-- deposit money to accounts
exec DepositMoney 1,5000;
exec DepositMoney 2,10000;
exec DepositMoney 3,100000;
exec DepositMoney 4,999999;
exec DepositMoney 5,250000;
exec DepositMoney 3,50000;

select * from AccountsWithOwners;

-- add yearly interests to all saving accounts
exec AddYearlyInterests;

select * from AccountsWithOwners;
select * from ActiveLoansWithOwners;

-- loan the money (transfer 10000 to account with Id 1)
exec AddLoan 1,10000,5000;

select * from AccountsWithOwners;
select * from ActiveLoansWithOwners;

-- pay the loan
exec PayMonthlyLoan 1,3;
exec PayMonthlyLoan 1,3;
exec PayMonthlyLoan 1,3;

select * from ActiveLoansWithOwners;
select * from AccountsWithOwners;

-- mark the completely paid loans as completed
exec MarkCompletedLoans;
select * from ActiveLoansWithOwners;

-- MONEY TRANSFERS

-- deposit money
select * from AccountsWithOwners;
exec DepositMoney 1,500;
select * from AccountsWithOwners;

-- withdraw some money
exec WithdrawMoney 2,1000;
exec WithdrawMoney 3,50000;

select * from AccountsWithOwners;

-- transfer money
exec TransferMoney 1,2,2500;
exec TransferMoney 3,1,2500;
exec TransferMoney 5,4,10000;
exec TransferMoney 5,4,15000;

select * from AccountsWithOwners;
select * from AllTransactions;

-- transfer another money
exec TransferMoney 2,3,250;
exec TransferMoney 5,2,400;
exec TransferMoney 4,1,10000.5;
exec TransferMoney 4,2,6666.66;

select * from AccountsWithOwners;
select * from AllTransactions;

-- display all in/out -coming transmissions with respect to the given account
exec GetAllIncomingTransactions 2;
exec GetAllOutcomingTransactions 2;

select * from AccountsWithOwners;

-- try to send more money than we have -> raises error and the transaction is rollbacked
exec TransferMoney 2,5,999999;
select * from AccountsWithOwners;
