CREATE TRIGGER trInsertCustomer
ON Customer
WITH ENCRYPTION
AFTER INSERT
AS
BEGIN
	INSERT INTO Ireland_db.dbo.Customer(idSubscription, emailAddress,
	                                    name, lastName1, lastName2, location,
	                                    userName, password)
	SELECT inserted.idSubscription, inserted.emailAddress,
	       inserted.name, inserted.lastName1, inserted.lastName2,
	       inserted.location, inserted.userName, inserted.password
	FROM inserted
    INSERT INTO UnitedStates_db.dbo.Customer(idSubscription, emailAddress,
	                                    name, lastName1, lastName2, location,
	                                    userName, password)
	SELECT inserted.idSubscription, inserted.emailAddress,
	       inserted.name, inserted.lastName1, inserted.lastName2,
	       inserted.location, inserted.userName, inserted.password
	FROM inserted
    INSERT INTO Scotland_db.dbo.Customer(idSubscription,  emailAddress,
	                                    name, lastName1, lastName2, location,
	                                    userName, password)
	SELECT inserted.idSubscription, inserted.emailAddress,
	       inserted.name, inserted.lastName1, inserted.lastName2,
	       inserted.location, inserted.userName, inserted.password
	FROM inserted
END