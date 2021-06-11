-- gets all account of the given client
create procedure GetAccountsOf
	@idClient int
as
	select a.Id, a.Number, a.Balance
	from Accounts a
	inner join Clients c on a.OwnerId = c.Id
	where c.Id = @idClient

go