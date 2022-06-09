DELIMITER //
CREATE PROCEDURE replicateUpdateCustomer (
    IN pIdCustomer int,
    IN pIdSubscription int,
    IN pEmailAddress varchar(64),
    IN pName varchar(64),
    IN pLastName1 varchar(64),
    IN pLastName2 varchar(64),
    IN pPoint varchar(64),
    IN pUserName varchar(64),
    IN pPassword varchar(64)
)
BEGIN
    DECLARE pLocation geometry;
    SET pLocation = ST_GeomFromText(pPoint);
    START TRANSACTION;
    UPDATE customer
    SET idSubscription = pIdSubscription,
        emailAddress = pEmailAddress,
        name = pName,
        lastName1 = pLastName1,
        lastName2 = pLastName2,
        location = pLocation,
        userName = pUserName,
        password = SHA2(pPassword, 256)
    WHERE idCustomer = pIdCustomer;
    SELECT 'Customer updated.';
    COMMIT;
END //
DELIMITER ;