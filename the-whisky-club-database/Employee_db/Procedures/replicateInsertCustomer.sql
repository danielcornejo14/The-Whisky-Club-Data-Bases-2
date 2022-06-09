DELIMITER //
CREATE PROCEDURE replicateInsertCustomer (
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
    INSERT INTO customer(idSubscription, emailAddress,
                         name, lastName1, lastName2,
                         location, userName, password)
    VALUES(pIdSubscription, pEmailAddress,
           pName, pLastName1, pLastName2,
           pLocation, pUserName, SHA2(pPassword, 256));
    SELECT 'Customer inserted.';
    COMMIT;
END //
DELIMITER ;