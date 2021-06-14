-- get number of months to pay to complete the loan
create function RemainingMonthsToPay(
	@idLoan int -- identifier of the loan
) returns int -- return number of months to pay
as
begin
	declare @remainingMonths float;

	select
		@remainingMonths = CAST(l.RemainingAmount AS float) / CAST(l.MonthlyPayment AS float)
	from Loans l
	where l.Id = @idLoan;

	return ceiling(@remainingMonths);
end

go
