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
    IF pIdSubscription IS NOT NULL AND pEmailAddress IS NOT NULL
        AND pName IS NOT NULL AND pLastName1 IS NOT NULL
        AND pLastName2 IS NOT NULL AND pPoint IS NOT NULL
        AND pUserName IS NOT NULL AND pPassword IS NOT NULL
    THEN
        START TRANSACTION;
        UPDATE customer
        SET idSubscription = pIdSubscription,
            emailAddress = pEmailAddress,
            name = pName,
            lastName1 = pLastName1,
            lastName2 = pLastName2,
            location = ST_GeomFromText(pPoint),
            userName = pUserName,
            password = SHA2(pPassword, 256)
        WHERE idCustomer = pIdCustomer;
        SELECT 'Customer updated.';
        COMMIT;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;