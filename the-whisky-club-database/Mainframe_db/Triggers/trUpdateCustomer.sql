CREATE TRIGGER trUpdateCustomer
ON Customer
WITH ENCRYPTION
AFTER UPDATE
AS
BEGIN
    UPDATE UnitedStates_db.dbo.Customer
    SET idSubscription = inserted.idSubscription,
        emailAddress = inserted.emailAddress,
        name = inserted.name,
        lastName1 = inserted.lastName1,
        lastName2 = inserted.lastName2,
        location = inserted.location,
        userName = inserted.userName,
        password = inserted.password,
        status = inserted.status
    FROM inserted
    WHERE UnitedStates_db.dbo.Customer.idCustomer = inserted.idCustomer
    UPDATE Scotland_db.dbo.Customer
    SET idSubscription = inserted.idSubscription,
        emailAddress = inserted.emailAddress,
        name = inserted.name,
        lastName1 = inserted.lastName1,
        lastName2 = inserted.lastName2,
        location = inserted.location,
        userName = inserted.userName,
        password = inserted.password,
        status = inserted.status
    FROM inserted
    WHERE Scotland_db.dbo.Customer.idCustomer = inserted.idCustomer
    UPDATE Ireland_db.dbo.Customer
    SET idSubscription = inserted.idSubscription,
        emailAddress = inserted.emailAddress,
        name = inserted.name,
        lastName1 = inserted.lastName1,
        lastName2 = inserted.lastName2,
        location = inserted.location,
        userName = inserted.userName,
        password = inserted.password,
        status = inserted.status
    FROM inserted
    WHERE Ireland_db.dbo.Customer.idCustomer = inserted.idCustomer
END