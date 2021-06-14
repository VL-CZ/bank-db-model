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
exec AddLoan 1,10000,1000;

select * from AccountsWithOwners;
select * from ActiveLoansWithOwners;

exec GetActiveLoansOf 2;
exec TotalMonthlyPaymentOf 2;

